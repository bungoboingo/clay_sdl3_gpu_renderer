package clay_renderer

import "core:c"
import "core:log"
import "core:mem"
import "core:os"
import sdl "library:sdl3"
import sdl_ttf "library:sdl3_ttf"

JETBRAINS_MONO_REGULAR: u16 : 0
JETBRAINS_MONO_BOLD: u16 : 1
NUM_FONTS :: 2
MAX_FONT_SIZE :: 120

tmp_text: [dynamic]Text

@(private = "file")
jetbrains_mono_regular := #load("res/fonts/JetBrainsMono-Regular.ttf")
@(private = "file")
jetbrains_mono_bold := #load("res/fonts/JetBrainsMono-Bold.ttf")

TextPipeline :: struct {
	engine:          ^sdl_ttf.TextEngine,
	fonts:           [NUM_FONTS][MAX_FONT_SIZE]^sdl_ttf.Font,
	sdl_pipeline:    ^sdl.GPUGraphicsPipeline,
	vertex_buffer:   Buffer,
	index_buffer:    Buffer,
	instance_buffer: Buffer,
	sampler:         ^sdl.GPUSampler,
}

get_font :: proc(id: u16, size: u16) -> ^sdl_ttf.Font {
	font := text_pipeline.fonts[id > 1 ? 0 : id][size > 0 ? size : 16]

	if font == nil {
		log.debug("Font not found for size", size, "+ adding")
		jb_mono_reg_rwops := sdl.IOFromConstMem(
			raw_data(jetbrains_mono_regular[:]),
			len(jetbrains_mono_regular),
		)
		f := sdl_ttf.OpenFontIO(jb_mono_reg_rwops, true, f32(size))
		if f == nil {
			log.error("Failed to font with size:", size, sdl.GetError())
			os.exit(1)
		}
		font = f
		sdl_ttf.SetFontSizeDPI(f, f32(size), 72 * i32(dpi_scaling), 72 * i32(dpi_scaling))
		text_pipeline.fonts[id][size] = f
	}

	return font
}

Text :: struct {
	ref:      ^sdl_ttf.Text,
	position: [2]f32,
	color:    [4]f32,
}

// For upload
TextVert :: struct {
	pos_uv: [4]f32,
	color:  [4]f32,
}

@(private)
create_text_pipeline :: proc(device: ^sdl.GPUDevice, window: ^sdl.Window) -> TextPipeline {
	if !sdl_ttf.Init() {
		log.error("Failed to initialize TTF", sdl.GetError())
		os.exit(1)
	}

	when ODIN_OS == .Darwin {
		vert_raw := #load("res/shaders/compiled/text.vert.metal")
		frag_raw := #load("res/shaders/compiled/text.frag.metal")
	} else {
		vert_raw := #load("res/shaders/compiled/text.vert.spv")
		frag_raw := #load("res/shaders/compiled/text.frag.spv")
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
		code_size    = len(frag_raw),
		code         = raw_data(frag_raw),
		entry_point  = ENTRY_POINT,
		format       = SHADER_TYPE,
		stage        = sdl.GPUShaderStage.FRAGMENT,
		num_samplers = 1,
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

	vertex_attributes: [3]sdl.GPUVertexAttribute = {
		// vertex position & uv
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 0,
			format = sdl.GPUVertexElementFormat.FLOAT4,
			offset = 0,
		},
		// color
		sdl.GPUVertexAttribute {
			buffer_slot = 0,
			location = 1,
			format = sdl.GPUVertexElementFormat.FLOAT4,
			offset = size_of(f32) * 4,
		},
		// Instance position data
		sdl.GPUVertexAttribute {
			buffer_slot = 1,
			location = 2,
			format = sdl.GPUVertexElementFormat.FLOAT2,
			offset = 0,
		},
	}

	buffer_descriptions: [2]sdl.GPUVertexBufferDescription = {
		sdl.GPUVertexBufferDescription{slot = 0, input_rate = .VERTEX, pitch = size_of(TextVert)},
		sdl.GPUVertexBufferDescription {
			slot = 1,
			input_rate = .INSTANCE,
			pitch = size_of([2]f32),
			instance_step_rate = 1,
		},
	}

	sampler_info := sdl.GPUSamplerCreateInfo {
		min_filter     = .LINEAR,
		mag_filter     = .LINEAR,
		mipmap_mode    = .LINEAR,
		address_mode_u = .CLAMP_TO_EDGE,
		address_mode_v = .CLAMP_TO_EDGE,
		address_mode_w = .CLAMP_TO_EDGE,
	}

	sampler := sdl.CreateGPUSampler(device, &sampler_info)
	if sampler == nil {
		log.error("Could not create GPU sampler:", sdl.GetError())
		os.exit(1)
	}

	pipeline_info := sdl.GPUGraphicsPipelineCreateInfo {
		vertex_shader = vert_shader,
		fragment_shader = frag_shader,
		primitive_type = .TRIANGLE_LIST,
		target_info = sdl.GPUGraphicsPipelineTargetInfo {
			color_target_descriptions = &sdl.GPUColorTargetDescription {
				format = sdl.GetGPUSwapchainTextureFormat(device, window),
				blend_state = sdl.GPUColorTargetBlendState {
					enable_blend = true,
					color_write_mask = sdl.GPUColorComponentFlags{.R, .G, .B, .A},
					alpha_blend_op = sdl.GPUBlendOp.ADD,
					src_alpha_blendfactor = sdl.GPUBlendFactor.SRC_ALPHA,
					dst_alpha_blendfactor = sdl.GPUBlendFactor.ONE_MINUS_SRC_ALPHA,
					color_blend_op = sdl.GPUBlendOp.ADD,
					src_color_blendfactor = sdl.GPUBlendFactor.SRC_ALPHA,
					dst_color_blendfactor = sdl.GPUBlendFactor.ONE_MINUS_SRC_ALPHA,
				},
			},
			num_color_targets = 1,
		},
		vertex_input_state = sdl.GPUVertexInputState {
			vertex_buffer_descriptions = raw_data(buffer_descriptions[:]),
			num_vertex_buffers = 2,
			vertex_attributes = raw_data(vertex_attributes[:]),
			num_vertex_attributes = 3,
		},
	}

	sdl_pipeline := sdl.CreateGPUGraphicsPipeline(device, &pipeline_info)
	if sdl_pipeline == nil {
		log.error("Failed to create quad graphics pipeline:", sdl.GetError())
		os.exit(1)
	}

	sdl.ReleaseGPUShader(device, vert_shader)
	sdl.ReleaseGPUShader(device, frag_shader)

	// Create engine
	engine := sdl_ttf.CreateGPUTextEngine(device)
	if engine == nil {
		log.error("Could not create text engine")
		os.exit(1)
	}
	sdl_ttf.SetGPUTextEngineWinding(engine, .COUNTERCLOCKWISE)

	// Create buffers
	vertex_buffer := create_buffer(
		device,
		size_of(TextVert) * BUFFER_INIT_SIZE,
		sdl.BUFFER_USAGE_VERTEX,
	)
	index_buffer := create_buffer(
		device,
		size_of(c.int) * BUFFER_INIT_SIZE,
		sdl.BUFFER_USAGE_INDEX,
	)
	instance_buffer := create_buffer(
		device,
		size_of([2]f32) * BUFFER_INIT_SIZE,
		sdl.BUFFER_USAGE_VERTEX,
	)

	pipeline := TextPipeline {
		engine,
		[NUM_FONTS][MAX_FONT_SIZE]^sdl_ttf.Font{},
		sdl_pipeline,
		vertex_buffer,
		index_buffer,
		instance_buffer,
		sampler,
	}

	return pipeline
}

@(private)
upload_text :: proc(device: ^sdl.GPUDevice, pass: ^sdl.GPUCopyPass) {
	vertices := make([dynamic]TextVert, 0, BUFFER_INIT_SIZE, context.temp_allocator)
	indices := make([dynamic]c.int, 0, BUFFER_INIT_SIZE, context.temp_allocator)
	instances := make([dynamic][2]f32, 0, BUFFER_INIT_SIZE, context.temp_allocator)

	for &text, index in tmp_text {
		append(&instances, text.position)
		data := sdl_ttf.GetGPUTextDrawData(text.ref)

		for data != nil {
			for i in 0 ..< data.num_verticies {
				pos := data.vertex_positions[i]
				uv := data.uvs[i]
				color := text.color
				append(&vertices, TextVert{{pos.x, -pos.y, uv.x, uv.y}, color})
			}
			append(&indices, ..data.indices[:data.num_indices])
			data = data.next
		}
	}

	// Resize buffers if needed
	vertices_size := u32(len(vertices) * size_of(TextVert))
	indices_size := u32(len(indices) * size_of(c.int))
	instances_size := u32(len(instances) * size_of([2]f32))

	resize_buffer(device, &text_pipeline.vertex_buffer, vertices_size, sdl.BUFFER_USAGE_VERTEX)
	resize_buffer(device, &text_pipeline.index_buffer, indices_size, sdl.BUFFER_USAGE_INDEX)
	resize_buffer(device, &text_pipeline.instance_buffer, instances_size, sdl.BUFFER_USAGE_VERTEX)

	vertex_array := sdl.MapGPUTransferBuffer(device, text_pipeline.vertex_buffer.transfer, true)
	mem.copy(vertex_array, raw_data(vertices), int(vertices_size))
	sdl.UnmapGPUTransferBuffer(device, text_pipeline.vertex_buffer.transfer)

	index_array := sdl.MapGPUTransferBuffer(device, text_pipeline.index_buffer.transfer, true)
	mem.copy(index_array, raw_data(indices), int(indices_size))
	sdl.UnmapGPUTransferBuffer(device, text_pipeline.index_buffer.transfer)

	instance_array := sdl.MapGPUTransferBuffer(
		device,
		text_pipeline.instance_buffer.transfer,
		true,
	)
	mem.copy(instance_array, raw_data(instances), int(instances_size))
	sdl.UnmapGPUTransferBuffer(device, text_pipeline.instance_buffer.transfer)

	sdl.UploadToGPUBuffer(
		pass,
		&sdl.GPUTransferBufferLocation{transfer_buffer = text_pipeline.vertex_buffer.transfer},
		&sdl.GPUBufferRegion {
			buffer = text_pipeline.vertex_buffer.gpu,
			offset = 0,
			size = vertices_size,
		},
		true,
	)

	sdl.UploadToGPUBuffer(
		pass,
		&sdl.GPUTransferBufferLocation{transfer_buffer = text_pipeline.index_buffer.transfer},
		&sdl.GPUBufferRegion {
			buffer = text_pipeline.index_buffer.gpu,
			offset = 0,
			size = indices_size,
		},
		true,
	)

	sdl.UploadToGPUBuffer(
		pass,
		&sdl.GPUTransferBufferLocation{transfer_buffer = text_pipeline.instance_buffer.transfer},
		&sdl.GPUBufferRegion {
			buffer = text_pipeline.instance_buffer.gpu,
			offset = 0,
			size = instances_size,
		},
		true,
	)
}

@(private)
draw_text :: proc(
	device: ^sdl.GPUDevice,
	window: ^sdl.Window,
	cmd_buffer: ^sdl.GPUCommandBuffer,
	swapchain_texture: ^sdl.GPUTexture,
	swapchain_w: u32,
	swapchain_h: u32,
	layer: ^Layer,
) {
	if layer.text_instance_len == 0 {
		return
	}

	render_pass := sdl.BeginGPURenderPass(
		cmd_buffer,
		&sdl.GPUColorTargetInfo {
			texture = swapchain_texture,
			load_op = sdl.GPULoadOp.LOAD,
			store_op = sdl.GPUStoreOp.STORE,
		},
		1,
		nil,
	)
	sdl.BindGPUGraphicsPipeline(render_pass, text_pipeline.sdl_pipeline)

	v_bindings: [2]sdl.GPUBufferBinding = {
		sdl.GPUBufferBinding{buffer = text_pipeline.vertex_buffer.gpu, offset = 0},
		sdl.GPUBufferBinding{buffer = text_pipeline.instance_buffer.gpu, offset = 0},
	}

	sdl.BindGPUVertexBuffers(render_pass, 0, raw_data(v_bindings[:]), 2)
	sdl.BindGPUIndexBuffer(
		render_pass,
		&sdl.GPUBufferBinding{buffer = text_pipeline.index_buffer.gpu, offset = 0},
		.BITS_32,
	)

	push_globals(cmd_buffer, f32(swapchain_w), f32(swapchain_h))

	atlas: ^sdl.GPUTexture

	layer_text := tmp_text[layer.text_instance_start:layer.text_instance_start +
	layer.text_instance_len]
	index_offset: u32 = layer.text_instance_start
	vertex_offset: i32 = i32(layer.text_vertex_start)
	instance_offset: u32 = layer.text_instance_start

	for &scissor, index in layer.scissors {
		if scissor.text_len == 0 {
			continue
		}

		if scissor.bounds.w == 0 || scissor.bounds.h == 0 {
			sdl.SetGPUScissor(render_pass, &sdl.Rect{0, 0, i32(swapchain_w), i32(swapchain_h)})
		} else {
			sdl.SetGPUScissor(render_pass, &scissor.bounds)
		}

		for &text in layer_text[scissor.text_start:scissor.text_start + scissor.text_len] {
			// TODO if text is outside scissor bounds, do not draw
			data := sdl_ttf.GetGPUTextDrawData(text.ref)

			for data != nil {
				if data.atlas_texture != atlas {
					sdl.BindGPUFragmentSamplers(
						render_pass,
						0,
						&sdl.GPUTextureSamplerBinding {
							texture = data.atlas_texture,
							sampler = text_pipeline.sampler,
						},
						1,
					)
					atlas = data.atlas_texture
				}

				sdl.DrawGPUIndexedPrimitives(
					render_pass,
					u32(data.num_indices),
					1,
					index_offset,
					vertex_offset,
					instance_offset,
				)

				index_offset += u32(data.num_indices)
				vertex_offset += data.num_verticies

				data = data.next
			}

			instance_offset += 1
		}
	}

	sdl.EndGPURenderPass(render_pass)
}

destroy_text_pipeline :: proc(device: ^sdl.GPUDevice) {
	destroy_buffer(device, &text_pipeline.vertex_buffer)
	destroy_buffer(device, &text_pipeline.index_buffer)
	sdl.ReleaseGPUGraphicsPipeline(device, text_pipeline.sdl_pipeline)
}
