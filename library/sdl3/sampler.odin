package sdl3
import "core:c"

foreign import lib "system:SDL3"

GPUSampler :: struct {}

GPUSamplerMipmapMode :: enum c.int {
	NEAREST,
	LINEAR,
}

GPUSamplerAddressMode :: enum c.int {
	REPEAT,
	MIRRORED_REPEAT,
	CLAMP_TO_EDGE,
}

GPUSamplerCreateInfo :: struct {
	min_filter:        GPUFilter,
	mag_filter:        GPUFilter,
	mipmap_mode:       GPUSamplerMipmapMode,
	address_mode_u:    GPUSamplerAddressMode,
	address_mode_v:    GPUSamplerAddressMode,
	address_mode_w:    GPUSamplerAddressMode,
	mip_lod_bias:      f32,
	max_anisotropy:    f32,
	compare_op:        GPUCompareOp,
	min_lod:           f32,
	max_lod:           f32,
	enable_anisotropy: bool,
	enable_compare:    bool,
	_:                 u8,
	_:                 u8,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	// `first_slot`: The fragment sampler slot to begin binding from
	BindGPUFragmentSamplers :: proc(render_pass: ^GPURenderPass, first_slot: u32, texture_sampler_bindings: [^]GPUTextureSamplerBinding, num_bindings: u32) ---
	BindGPUVertexSamplers :: proc(render_pass: ^GPURenderPass, first_slot: u32, texture_sampler_bindings: [^]GPUTextureSamplerBinding, num_bindings: u32) ---
	CreateGPUSampler :: proc(device: ^GPUDevice, create_info: ^GPUSamplerCreateInfo) -> ^GPUSampler ---
	ReleaseGPUSampler :: proc(device: ^GPUDevice, sampler: ^GPUSampler) ---
}
