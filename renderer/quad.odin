package clay_renderer

import "core:log"
import "core:mem"
import "core:os"
import sdl "library:sdl3"

tmp_quads: [dynamic]Quad

QuadPipeline :: struct {
	instance_buffer: Buffer,
	num_instances:   u32,
	sdl_pipeline:    ^sdl.GPUGraphicsPipeline,
}

Quad :: struct {
	position_scale: [4]f32,
	corner_radii:   [4]f32,
	color:          [4]f32,
	border_color:   [4]f32,
	border_width:   f32,
	_:              [3]f32,
}

@(private)
create_quad_pipeline :: proc(device: ^sdl.GPUDevice, window: ^sdl.Window) -> QuadPipeline {
	when ODIN_OS == .Darwin {
		vert_raw := #load("res/shaders/compiled/quad.vert.metal")
		frag_raw := #load("res/shaders/compiled/quad.frag.metal")
	} else {
		vert_raw := #load("res/shaders/compiled/quad.vert.spv")
		frag_raw := #load("res/shaders/compiled/quad.frag.spv")
	}

	log.debug("Loaded", len(vert_raw), "vert bytes")
	log.debug("Loaded", len(frag_raw), "frag bytes")

	vert_info := sdl.GPUShaderCreateInfo {
		code_size           = len(vert_raw),
		code                = raw_data(vert_raw),
		entry_point         = ENTRY_POINT,
		format              = SHADER_TYPE,
		stage               = sdl.GPUShaderStage.VERTEX,
		num_uniform_buffers = 1,
	}

	frag_info := sdl.GPUShaderCreateInfo {
		code_size   = len(frag_raw),
		code        = raw_data(frag_raw),
		entry_point = ENTRY_POINT,
		format      = SHADER_TYPE,
		stage       = sdl.GPUShaderStage.FRAGMENT,
	}

	vert_shader := sdl.CreateGPUShader(device, &vert_info)
	if vert_shader == nil {
		log.error("Could not create vertex shader:", sdl.GetError())
		os.exit(1)
	}

	frag_shader := sdl.CreateGPUShader(device, &frag_info)
	if frag_shader == nil {
		log.error("Could not create fragment shader:", sdl.GetError())
		os.exit(1)
	}

	vertex_attributes: [5]sdl.GPUVertexAttribute = {
		// position and scale
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 0,
			format = sdl.GPUVertexElementFormat.FLOAT4,
			offset = 0,
		},
		// corner radii
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 1,
			format = sdl.GPUVertexElementFormat.FLOAT4,
			offset = size_of(f32) * 4,
		},
		// color
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 2,
			format = sdl.GPUVertexElementFormat.FLOAT4,
			offset = size_of(f32) * 8,
		},
		// border color
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 3,
			format = sdl.GPUVertexElementFormat.FLOAT4,
			offset = size_of(f32) * 12,
		},
		// border width
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 4,
			format = sdl.GPUVertexElementFormat.FLOAT,
			offset = size_of(f32) * 16,
		},
	}

	pipeline_info := sdl.GPUGraphicsPipelineCreateInfo {
		vertex_shader = vert_shader,
		fragment_shader = frag_shader,
		primitive_type = .TRIANGLE_LIST,
		target_info = sdl.GPUGraphicsPipelineTargetInfo {
			color_target_descriptions = &sdl.GPUColorTargetDescription {
				format = sdl.GetGPUSwapchainTextureFormat(device, window),
				blend_state = sdl.GPUColorTargetBlendState {
					src_color_blendfactor = .SRC_ALPHA,
					dst_color_blendfactor = .ONE_MINUS_SRC_ALPHA,
					color_blend_op = .ADD,
					src_alpha_blendfactor = .ONE,
					dst_alpha_blendfactor = .ONE_MINUS_SRC_ALPHA,
					alpha_blend_op = .ADD,
					color_write_mask = sdl.GPUColorComponentFlags{.R, .G, .B, .A},
					enable_blend = true,
					enable_color_write_mask = true,
				},
			},
			num_color_targets = 1,
		},
		vertex_input_state = sdl.GPUVertexInputState {
			vertex_buffer_descriptions = &sdl.GPUVertexBufferDescription {
				slot = 0,
				input_rate = sdl.GPUVertexInputRate.INSTANCE,
				instance_step_rate = 1,
				pitch = size_of(Quad),
			},
			num_vertex_buffers = 1,
			vertex_attributes = raw_data(vertex_attributes[:]),
			num_vertex_attributes = 5,
		},
	}

	sdl_pipeline := sdl.CreateGPUGraphicsPipeline(device, &pipeline_info)
	if sdl_pipeline == nil {
		log.error("Failed to create quad graphics pipeline:", sdl.GetError())
		os.exit(1)
	}

	sdl.ReleaseGPUShader(device, vert_shader)
	sdl.ReleaseGPUShader(device, frag_shader)

	// Create buffers
	instance_buffer := create_buffer(
		device,
		size_of(Quad) * BUFFER_INIT_SIZE,
		sdl.BUFFER_USAGE_VERTEX,
	)

	pipeline := QuadPipeline{instance_buffer, BUFFER_INIT_SIZE, sdl_pipeline}

	return pipeline
}

@(private)
upload_quads :: proc(device: ^sdl.GPUDevice, pass: ^sdl.GPUCopyPass) {
	num_quads := u32(len(tmp_quads))
	size := num_quads * size_of(Quad)

	resize_buffer(device, &quad_pipeline.instance_buffer, size, sdl.BUFFER_USAGE_VERTEX)

	// Write data
	i_array := sdl.MapGPUTransferBuffer(device, quad_pipeline.instance_buffer.transfer, false)
	mem.copy(i_array, raw_data(tmp_quads), int(size))
	sdl.UnmapGPUTransferBuffer(device, quad_pipeline.instance_buffer.transfer)

	// Upload
	sdl.UploadToGPUBuffer(
		pass,
		&sdl.GPUTransferBufferLocation{transfer_buffer = quad_pipeline.instance_buffer.transfer},
		&sdl.GPUBufferRegion{buffer = quad_pipeline.instance_buffer.gpu, offset = 0, size = size},
		false, // TODO figure out what cycling actually does
	)
}

@(private)
draw_quads :: proc(
	device: ^sdl.GPUDevice,
	window: ^sdl.Window,
	cmd_buffer: ^sdl.GPUCommandBuffer,
	swapchain_texture: ^sdl.GPUTexture,
	swapchain_w: u32,
	swapchain_h: u32,
	layer: ^Layer,
	load_op: sdl.GPULoadOp,
) {
	if layer.quad_len == 0 {
		return
	}

	render_pass := sdl.BeginGPURenderPass(
		cmd_buffer,
		&sdl.GPUColorTargetInfo {
			texture = swapchain_texture,
			clear_color = sdl.FColor{1.0, 1.0, 1.0, 1.0},
			load_op = load_op,
			store_op = sdl.GPUStoreOp.STORE,
		},
		1,
		nil,
	)
	sdl.BindGPUGraphicsPipeline(render_pass, quad_pipeline.sdl_pipeline)

	sdl.BindGPUVertexBuffers(
		render_pass,
		0,
		&sdl.GPUBufferBinding{buffer = quad_pipeline.instance_buffer.gpu, offset = 0},
		1,
	)
	push_globals(cmd_buffer, f32(swapchain_w), f32(swapchain_h))

	quad_offset := layer.quad_instance_start

	for &scissor, index in layer.scissors {
		if scissor.quad_len == 0 {
			continue
		}

		if scissor.bounds.w == 0 || scissor.bounds.h == 0 {
			sdl.SetGPUScissor(render_pass, &sdl.Rect{0, 0, i32(swapchain_w), i32(swapchain_h)})
		} else {
			sdl.SetGPUScissor(render_pass, &scissor.bounds)
		}

		sdl.DrawGPUPrimitives(render_pass, 6, scissor.quad_len, 0, quad_offset)
		quad_offset += scissor.quad_len
	}
	sdl.EndGPURenderPass(render_pass)
}

destroy_quad_pipeline :: proc(device: ^sdl.GPUDevice) {
	destroy_buffer(device, &quad_pipeline.instance_buffer)
	sdl.ReleaseGPUGraphicsPipeline(device, quad_pipeline.sdl_pipeline)
}
