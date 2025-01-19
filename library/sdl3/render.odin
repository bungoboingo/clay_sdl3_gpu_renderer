package sdl3

import "core:c"

foreign import lib "system:SDL3"

GPURenderPass :: struct {}
GPUGraphicsPipeline :: struct {}
GPUViewport :: struct {
	x:         f32,
	y:         f32,
	w:         f32,
	h:         f32,
	min_depth: f32,
	max_depth: f32,
}

GPUColorTargetInfo :: struct {
	// The texture that will be used as a color target by a render pass
	texture:               ^GPUTexture,
	// The mip level to use as a color target
	mip_level:             u32,
	// The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
	layer_or_depth_plane:  u32,
	// The color to clear the color target to at the start of the render pass. Ignored if LOADOP_CLEAR is not used.
	clear_color:           FColor,
	// What is done with the contents of the color target at the beginning of the render pass.
	load_op:               GPULoadOp,
	// What is done with the results of the render pass.
	store_op:              GPUStoreOp,
	// The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used.
	resolve_texture:       ^GPUTexture,
	// The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
	resolve_mip_level:     u32,
	// The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
	resolve_layer:         u32,
	// `true` cycles the texture if the texture is bound and load_op is not LOAD
	cycle:                 bool,
	// `true` cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used.
	cycle_resolve_texture: bool,
	_:                     u8,
	_:                     u8,
}

GPUDepthStencilTargetInfo :: struct {
	// The texture that will be used as the depth stencil target by the render pass.
	texture:          ^GPUTexture,
	// The value to clear the depth component to at the beginning of the render pass. Ignored if LOADOP_CLEAR is not used.
	clear_depth:      f32,
	// What is done with the depth contents at the beginning of the render pass.
	load_op:          GPULoadOp,
	// What is done with the depth results of the render pass.
	store_op:         GPUStoreOp,
	// What is done with the stencil contents at the beginning of the render pass.
	stencil_load_op:  GPULoadOp,
	// What is done with the stencil results of the render pass.
	stencil_store_op: GPUStoreOp,
	// true cycles the texture if the texture is bound and any load ops are not LOAD
	cyclce:           bool,
	// The value to clear the stencil component to at the beginning of the render pass. Ignored if LOADOP_CLEAR is not used.
	clear_stencil:    u8,
	_:                u8,
	_:                u8,
}

GPUVertexElementFormat :: enum c.int {
	INVALID,

	/* 32-bit Signed Integers */
	INT,
	INT2,
	INT3,
	INT4,

	/* 32-bit Unsigned Integers */
	UINT,
	UINT2,
	UINT3,
	UINT4,

	/* 32-bit Floats */
	FLOAT,
	FLOAT2,
	FLOAT3,
	FLOAT4,

	/* 8-bit Signed Integers */
	BYTE2,
	BYTE4,

	/* 8-bit Unsigned Integers */
	UBYTE2,
	UBYTE4,

	/* 8-bit Signed Normalized */
	BYTE2_NORM,
	BYTE4_NORM,

	/* 8-bit Unsigned Normalized */
	UBYTE2_NORM,
	UBYTE4_NORM,

	/* 16-bit Signed Integers */
	SHORT2,
	SHORT4,

	/* 16-bit Unsigned Integers */
	USHORT2,
	USHORT4,

	/* 16-bit Signed Normalized */
	SHORT2_NORM,
	SHORT4_NORM,

	/* 16-bit Unsigned Normalized */
	USHORT2_NORM,
	USHORT4_NORM,

	/* 16-bit Floats */
	HALF2,
	HALF4,
}

GPUVertexAttribute :: struct {
	// Shader input location index
	location:    u32,
	// Binding slot of the associated vertex buffer
	buffer_slot: u32,
	// Size & type of attribute data
	format:      GPUVertexElementFormat,
	// The byte offset of this attribute relative to the start of the vertex element
	offset:      u32,
}

GPUVertexInputRate :: enum c.int {
	VERTEX,
	INSTANCE,
}

GPUVertexBufferDescription :: struct {
	slot:               u32,
	// Byte pitch between consecutive elements of the vertex buffer
	pitch:              u32,
	// Whether attribute addressing is a function of the vertex index or instance index
	input_rate:         GPUVertexInputRate,
	// The number of instances to draw using the same per-instance data before advancing in the instance buffer by one element.
	// Ignored unless input_rate is VERTEXINPUTRATE_INSTANCE
	instance_step_rate: u32,
}

GPUVertexInputState :: struct {
	vertex_buffer_descriptions: [^]GPUVertexBufferDescription,
	num_vertex_buffers:         u32,
	vertex_attributes:          [^]GPUVertexAttribute,
	num_vertex_attributes:      u32,
}

GPUPrimitiveType :: enum c.int {
	TRIANGLE_LIST,
	TRIANGLE_STRIP,
	LINE_LIST,
	LINE_STRIP,
	POINT_LIST,
}

GPUFillMode :: enum c.int {
	FILL,
	LINE,
}

GPUCullMode :: enum c.int {
	NONE,
	FRONT,
	BACK,
}

GPUFrontFace :: enum c.int {
	COUNTER_CLOCKWISE,
	CLOCKWISE,
}

GPURasterizerState :: struct {
	fill_mode:                  GPUFillMode,
	cull_mode:                  GPUCullMode,
	front_face:                 GPUFrontFace,
	depth_bias_constant_factor: f32,
	depth_bias_clamp:           f32,
	depth_bias_slope_factor:    f32,
	enable_depth_bias:          bool,
	enable_depth_clip:          bool,
	_:                          u8,
	_:                          u8,
}

GPUSampleCount :: enum c.int {
	COUNT_1,
	COUNT_2,
	COUNT_4,
	COUNT_8,
}

GPUMultisampleState :: struct {
	sample_count: GPUSampleCount,
	sample_mask:  u32,
	enable_mask:  bool,
	_:            u8,
	_:            u8,
	_:            u8,
}

GPUDepthStencilState :: struct {
	compare_op:          GPUCompareOp,
	back_stencil_state:  GPUStencilOpState,
	front_stencil_state: GPUStencilOpState,
	compare_mask:        u8,
	write_mask:          u8,
	enable_depth_test:   bool,
	enable_depth_write:  bool,
	enable_stencil_test: bool,
	_:                   u8,
	_:                   u8,
	_:                   u8,
}

GPUBlendFactor :: enum c.int {
	INVALID,
	ZERO,
	ONE,
	SRC_COLOR,
	ONE_MINUS_SRC_COLOR,
	DST_COLOR,
	ONE_MINUS_DST_COLOR,
	SRC_ALPHA,
	ONE_MINUS_SRC_ALPHA,
	DST_ALPHA,
	ONE_MINUS_DST_ALPHA,
	CONSTANT_COLOR, // blend constant
	ONE_MINUS_CONSTANT_COLOR,
	SRC_ALPHA_SATURATE, // min(src_alpha, 1 - dst_alpha)
}

GPUColorComponentFlag :: enum u8 {
	R,
	G,
	B,
	A,
}

GPUColorComponentFlags :: bit_set[GPUColorComponentFlag;u8]

COLOR_COMPONENT_FLAG_R :: GPUColorComponentFlags{.R}
COLOR_COMPONENT_FLAG_G :: GPUColorComponentFlags{.G}
COLOR_COMPONENT_FLAG_B :: GPUColorComponentFlags{.B}
COLOR_COMPONENT_FLAG_A :: GPUColorComponentFlags{.A}

GPUColorTargetBlendState :: struct {
	src_color_blendfactor:   GPUBlendFactor,
	dst_color_blendfactor:   GPUBlendFactor,
	color_blend_op:          GPUBlendOp,
	src_alpha_blendfactor:   GPUBlendFactor,
	dst_alpha_blendfactor:   GPUBlendFactor,
	alpha_blend_op:          GPUBlendOp,
	color_write_mask:        GPUColorComponentFlags,
	enable_blend:            bool,
	enable_color_write_mask: bool,
	_:                       u8,
	_:                       u8,
}

GPUColorTargetDescription :: struct {
	format:      GPUTextureFormat,
	blend_state: GPUColorTargetBlendState,
}

GPUGraphicsPipelineTargetInfo :: struct {
	color_target_descriptions: [^]GPUColorTargetDescription,
	num_color_targets:         u32,
	depht_stencil_format:      GPUTextureFormat,
	has_depth_stencil_target:  bool,
	_:                         u8,
	_:                         u8,
	_:                         u8,
}

GPUGraphicsPipelineCreateInfo :: struct {
	vertex_shader:       ^GPUShader,
	fragment_shader:     ^GPUShader,
	vertex_input_state:  GPUVertexInputState,
	primitive_type:      GPUPrimitiveType,
	rasterizer_state:    GPURasterizerState,
	multisample_state:   GPUMultisampleState,
	depth_stencil_state: GPUDepthStencilState,
	target_info:         GPUGraphicsPipelineTargetInfo,
	props:               PropertiesID,
}

// Note that the first_vertex and first_instance parameters are NOT compatible with built-in vertex/instance ID variables in shaders
// (for example, SV_VertexID). If your shader depends on these variables, the correlating draw call parameter MUST be 0.
GPUIndexedIndirectDrawCommand :: struct {
	num_indices:    u32,
	num_instances:  u32,
	first_index:    u32,
	vertex_offset:  i32,
	first_instance: u32,
}

GPUIndirectDispatchCommand :: struct {
	groupcount_x: u32,
	groupcount_y: u32,
	groupcount_z: u32,
}

GPUIndirectDrawCommand :: struct {
	num_indices:    u32,
	num_instances:  u32,
	first_vertex:   u32,
	first_instance: u32,
}

GPUCubeMapFace :: enum c.int {
	POSITIVE_X,
	NEGATIVE_X,
	POSITIVE_Y,
	NEGATIVE_Y,
	POSITIVE_Z,
	NEGATIVE_Z,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	BeginGPURenderPass :: proc(command_buffer: ^GPUCommandBuffer, color_target_infos: [^]GPUColorTargetInfo, num_color_targets: u32, depth_stencil_target_info: ^GPUDepthStencilTargetInfo) -> ^GPURenderPass ---
	BindGPUGraphicsPipeline :: proc(render_pass: ^GPURenderPass, graphics_pipeline: ^GPUGraphicsPipeline) ---
	CreateGPUGraphicsPipeline :: proc(device: ^GPUDevice, create_info: ^GPUGraphicsPipelineCreateInfo) -> ^GPUGraphicsPipeline ---
	DrawGPUIndexedPrimitives :: proc(render_pass: ^GPURenderPass, num_indices: u32, num_instances: u32, first_index: u32 = 0, vertex_offset: i32 = 0, first_instance: u32 = 0) ---
	DrawGPUIndexedPrimitivesIndirect :: proc(render_pass: ^GPURenderPass, buffer: ^GPUBuffer, offset: u32, draw_count: u32) ---
	DrawGPUPrimitives :: proc(render_pass: ^GPURenderPass, num_vertices: u32, num_instances: u32, first_vertex: u32 = 0, first_instance: u32 = 0) ---
	EndGPURenderPass :: proc(render_pass: ^GPURenderPass) ---
	PushGPUFragmentUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: u32, data: rawptr, length: u32) ---
	PushGPUVertexUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: u32, data: rawptr, length: u32) ---
	ReleaseGPUGraphicsPipeline :: proc(device: ^GPUDevice, pipeline: ^GPUGraphicsPipeline) ---
	// Sets the current blend constants on a command buffer
	SetGPUBlendConstants :: proc(pass: ^GPURenderPass, constants: ^FColor) ---
	// Sets the current scissor state on a command buffer
	SetGPUScissor :: proc(pass: ^GPURenderPass, scissor: ^Rect) ---
	// Sets the current stencil reference value on a command buffer
	SetGPUStencilReference :: proc(pass: ^GPURenderPass, ref: u8) ---
	SetGPUViewport :: proc(pass: ^GPURenderPass, viewport: ^GPUViewport) ---
}
