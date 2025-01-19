package clay_renderer

import "core:c"
import "core:log"
import "core:os"
import "core:strings"
import "base:runtime"
import clay "library:clay-odin"
import sdl "library:sdl3"
import sdl_ttf "library:sdl3_ttf"

odin_context : runtime.Context

when ODIN_OS == .Darwin {
	SHADER_TYPE :: sdl.GPUShaderFormat.MSL
	ENTRY_POINT :: "main0"
} else {
	SHADER_TYPE :: sdl.GPUShaderFormat.SPIRV
	ENTRY_POINT :: "main"
}

BUFFER_INIT_SIZE: u32 : 256

dpi_scaling: f32 = 1.0
layers: [dynamic]Layer
quad_pipeline: QuadPipeline
text_pipeline: TextPipeline

// TODO New layer for each z-index/batch when Clay supports it
Layer :: struct {
	quad_instance_start: u32,
	quad_len:            u32,
	text_instance_start: u32,
	text_instance_len:   u32,
	text_vertex_start:   u32,
	text_vertex_len:     u32,
	text_index_start:    u32,
	text_index_len:      u32,
	scissors:            [dynamic]Scissor,
}

Scissor :: struct {
	bounds:     sdl.Rect,
	quad_start: u32,
	quad_len:   u32,
	text_start: u32,
	text_len:   u32,
}

init :: proc(device: ^sdl.GPUDevice, window: ^sdl.Window, window_width: f32, window_height: f32) {
	dpi_scaling = sdl.GetWindowDisplayScale(window)
	log.debug("Window DPI scaling:", dpi_scaling)

	min_memory_size: u32 = clay.MinMemorySize()
	memory := make([^]u8, min_memory_size)
	arena := clay.CreateArenaWithCapacityAndMemory(min_memory_size, memory)
	clay.SetMeasureTextFunction(measure_text)
	clay.Initialize(arena, {window_width, window_height}, {handler = clay_error_handler})
	quad_pipeline = create_quad_pipeline(device, window)
	text_pipeline = create_text_pipeline(device, window)
}

clay_error_handler :: proc "c" (errorData: clay.ErrorData) {
	context = odin_context
	log.error("Clay error:", errorData.errorType, errorData.errorText)
}

@(private = "file")
measure_text :: proc "c" (text: ^clay.String, config: ^clay.TextElementConfig) -> clay.Dimensions {
	context = odin_context
	text := string(text.chars[:text.length])
	c_text := strings.clone_to_cstring(text, context.temp_allocator)
	w, h: c.int
	if !sdl_ttf.GetStringSize(get_font(config.fontId, config.fontSize), c_text, 0, &w, &h) {
		log.error("Failed to measure text", sdl.GetError())
	}

	return clay.Dimensions{width = f32(w) / dpi_scaling, height = f32(h) / dpi_scaling}
}

destroy :: proc(device: ^sdl.GPUDevice) {
	destroy_quad_pipeline(device)
	destroy_text_pipeline(device)
}

/// Upload data to the GPU
prepare :: proc(
	device: ^sdl.GPUDevice,
	window: ^sdl.Window,
	cmd_buffer: ^sdl.GPUCommandBuffer,
	render_commands: ^clay.ClayArray(clay.RenderCommand),
	mouse_delta: [2]f32,
	frame_time: f32,
) {
	mouse_x, mouse_y: f32
	mouse_flags := sdl.GetMouseState(&mouse_x, &mouse_y)
	// Currently MacOS blocks main thread when resizing, this will be fixed with next SDL3 release
	window_w, window_h: c.int
	window_size := sdl.GetWindowSize(window, &window_w, &window_h)

	// Update clay internals
	// TODO update this from touch as well
	clay.SetPointerState(clay.Vector2{mouse_x, mouse_y}, .LEFT in mouse_flags)
	clay.UpdateScrollContainers(true, transmute(clay.Vector2)mouse_delta, frame_time)
	clay.SetLayoutDimensions({f32(window_w), f32(window_h)})

	clear(&layers)
	clear(&tmp_quads)
	clear(&tmp_text)

	tmp_quads = make([dynamic]Quad, 0, quad_pipeline.num_instances, context.temp_allocator)
	tmp_text = make([dynamic]Text, 0, 20, context.temp_allocator)

	layer := Layer {
		scissors = make([dynamic]Scissor, 0, 10, context.temp_allocator),
	}
	scissor := Scissor{}

	// Parse render commands
	for i in 0 ..< int(render_commands.length) {
		render_command := clay.RenderCommandArray_Get(render_commands, cast(i32)i)
		bounds := render_command.boundingBox

		switch (render_command.commandType) {
		case clay.RenderCommandType.None:
		case clay.RenderCommandType.Text:
			text_config: ^clay.TextElementConfig = render_command.config.textElementConfig
			text := string(render_command.text.chars[:render_command.text.length])
			c_text := strings.clone_to_cstring(text, context.temp_allocator)
			sdl_text := sdl_ttf.CreateText(
				text_pipeline.engine,
				get_font(text_config.fontId, text_config.fontSize),
				c_text,
				0,
			)
			data := sdl_ttf.GetGPUTextDrawData(sdl_text)

			if sdl_text == nil {
				log.error("Could not create SDL text:", sdl.GetError())
			} else {
				append(
					&tmp_text,
					Text{sdl_text, {bounds.x, bounds.y}, f32_color(text_config.textColor)},
				)
				layer.text_instance_len += 1
				layer.text_vertex_len += u32(data.num_verticies)
				layer.text_index_len += u32(data.num_indices)
				scissor.text_len += 1
			}
		case clay.RenderCommandType.Image:
		case clay.RenderCommandType.ScissorStart:
			bounds := sdl.Rect {
				c.int(bounds.x * dpi_scaling),
				c.int(bounds.y * dpi_scaling),
				c.int(bounds.width * dpi_scaling),
				c.int(bounds.height * dpi_scaling),
			}
			new := new_scissor(&scissor)
			if scissor.quad_len != 0 || scissor.text_len != 0 {
				append(&layer.scissors, scissor)
			}
			scissor = new
			scissor.bounds = bounds
		case clay.RenderCommandType.ScissorEnd:
			new := new_scissor(&scissor)
			if scissor.quad_len != 0 || scissor.text_len != 0 {
				append(&layer.scissors, scissor)
			}
			scissor = new
		case clay.RenderCommandType.Rectangle:
			rect_config: ^clay.RectangleElementConfig =
				render_command.config.rectangleElementConfig
			color := f32_color(rect_config.color)
			cr := rect_config.cornerRadius
			quad := Quad {
				position_scale = {bounds.x, bounds.y, bounds.width, bounds.height},
				corner_radii   = {cr.topLeft, cr.topRight, cr.bottomRight, cr.bottomLeft},
				color          = color,
			}
			append(&tmp_quads, quad)
			layer.quad_len += 1
			scissor.quad_len += 1
		case clay.RenderCommandType.Border:
			border_config: ^clay.BorderElementConfig = render_command.config.borderElementConfig
			// Technically clay supports different colors for each side but we're not going to do that right now
			cr := border_config.cornerRadius
			quad := Quad {
				position_scale = {bounds.x, bounds.y, bounds.width, bounds.height},
				corner_radii   = {cr.topLeft, cr.topRight, cr.bottomRight, cr.bottomLeft},
				// We are abusing the right color slot to get the proper blend color for the fragment shader
				// the debug menu items set the border colors are identical all around, so we just hard-check that here
				// this is a bit of a hack
				color          = border_config.right.color == border_config.top.color ? f32_color(clay.Color{border_config.top.color.r, border_config.top.color.g, border_config.top.color.b, 0.0}) : f32_color(border_config.right.color),
				border_color   = f32_color(border_config.top.color),
				border_width   = f32(border_config.top.width),
			}
			// Technically these should be drawn on top of everything else including children, but
			// for our use case we can just chuck these in with the quad pipeline
			append(&tmp_quads, quad)
			layer.quad_len += 1
			scissor.quad_len += 1
		case clay.RenderCommandType.Custom:
		}
	}

	//TODO start new layers with z-index changes
	append(&layer.scissors, scissor)
	append(&layers, layer)

	// Upload primitives to GPU
	copy_pass := sdl.BeginGPUCopyPass(cmd_buffer)
	upload_quads(device, copy_pass)
	upload_text(device, copy_pass)
	sdl.EndGPUCopyPass(copy_pass)
}

/// Render primitives
draw :: proc(device: ^sdl.GPUDevice, window: ^sdl.Window, cmd_buffer: ^sdl.GPUCommandBuffer) {
	swapchain_texture: ^sdl.GPUTexture
	w, h: u32
	if !sdl.WaitAndAcquireGPUSwapchainTexture(cmd_buffer, window, &swapchain_texture, &w, &h) {
		log.error("Failed to acquire swapchain texture:", sdl.GetError())
		os.exit(1)
	}

	if swapchain_texture == nil {
		log.error("Failed to acquire swapchain texture:", sdl.GetError())
		os.exit(1)
	}

	for &layer, index in layers {
		draw_quads(
			device,
			window,
			cmd_buffer,
			swapchain_texture,
			w,
			h,
			&layer,
			index == 0 ? sdl.GPULoadOp.CLEAR : sdl.GPULoadOp.LOAD,
		)
		draw_text(device, window, cmd_buffer, swapchain_texture, w, h, &layer)
		//TODO draw other primitives in layer
	}
}

ortho_rh :: proc(
	left: f32,
	right: f32,
	bottom: f32,
	top: f32,
	near: f32,
	far: f32,
) -> matrix[4, 4]f32 {
	return matrix[4, 4]f32{
		2.0 / (right - left), 0.0, 0.0, -(right + left) / (right - left), 
		0.0, 2.0 / (top - bottom), 0.0, -(top + bottom) / (top - bottom), 
		0.0, 0.0, -2.0 / (far - near), -(far + near) / (far - near), 
		0.0, 0.0, 0.0, 1.0, 
	}
}

f32_color :: proc(color: clay.Color) -> [4]f32 {
	return [4]f32{color.x / 255.0, color.y / 255.0, color.z / 255.0, color.w / 255.0}
}

Globals :: struct {
	projection: matrix[4, 4]f32,
	scale:      f32,
}

push_globals :: proc(cmd_buffer: ^sdl.GPUCommandBuffer, w: f32, h: f32) {
	globals := Globals {
		ortho_rh(left = 0.0, top = 0.0, right = f32(w), bottom = f32(h), near = -1.0, far = 1.0),
		dpi_scaling,
	}

	sdl.PushGPUVertexUniformData(cmd_buffer, 0, &globals, size_of(Globals))
}

new_scissor :: proc(old: ^Scissor) -> Scissor {
	return Scissor {
		quad_start = old.quad_start + old.quad_len,
		text_start = old.text_start + old.text_len,
	}
}
