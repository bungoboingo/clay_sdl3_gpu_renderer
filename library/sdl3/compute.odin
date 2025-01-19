package sdl3
import "core:c"

foreign import lib "system:SDL3"

GPUComputePass :: struct {}
GPUComputePipeline :: struct {}

GPUComputePipelineCreateInfo :: struct {
	code_size:                      c.size_t,
	code:                           ^u8,
	entry_point:                    cstring,
	format:                         GPUShaderFormat,
	num_samplers:                   u32,
	num_readonly_storage_textures:  u32,
	num_readonly_storage_buffers:   u32,
	num_readwrite_storage_textures: u32,
	num_readwrite_storage_buffers:  u32,
	num_uniform_buffers:            u32,
	threadcount_x:                  u32,
	threadcount_y:                  u32,
	threadcount_z:                  u32,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	BeginGPUComputePass :: proc(command_buffer: ^GPUCommandBuffer, storage_texture_bindings: [^]GPUStorageTextureReadWriteBinding, num_storage_texture_bindings: u32, storage_buffer_bindings: [^]GPUStorageBufferReadWriteBinding, num_storage_buffer_bindings: u32) -> ^GPUComputePass ---
	BindGPUComputePipeline :: proc(compute_pass: ^GPUComputePass, compute_pipeline: ^GPUComputePipeline) ---
	BindGPUComputeSamplers :: proc(compute_pass: ^GPUComputePass, first_slot: u32, texture_sampler_bindings: [^]GPUTextureSamplerBinding, num_bindings: u32) ---
	BindGPUComputeStorageBuffers :: proc(compute_pass: ^GPUComputePass, first_slot: u32, storage_buffers: ^[^]GPUBuffer, num_bindings: u32) ---
	BindGPUComputeStorageTextures :: proc(compute_pass: ^GPUComputePass, first_slot: u32, storage_textures: ^[^]GPUTexture, num_bindings: u32) ---
	CreateGPUComputePipeline :: proc(device: ^GPUDevice, create_info: ^GPUComputePipelineCreateInfo) -> ^GPUComputePipeline ---
	DispatchGPUCompute :: proc(compute_pass: ^GPUComputePass, group_count_x: u32, group_count_y: u32, group_count_z: u32) ---
	DispatchGPUComputeIndirect :: proc(compute_pass: ^GPUComputePass, buffer: ^GPUBuffer, offset: u32) ---
	EndComputePass :: proc(compute_pass: ^GPUComputePass) ---
	PushGPUComputeUniformData :: proc(command_buffer: ^GPUCommandBuffer, slot_index: u32, data: rawptr, length: u32) ---
	ReleaseGPUComputePipeline :: proc(device: ^GPUDevice, pipeline: ^GPUComputePipeline) ---
}
