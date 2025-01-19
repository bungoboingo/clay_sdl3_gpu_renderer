package sdl3
import "core:c"

foreign import lib "system:SDL3"

GPUShaderFormat :: enum u32 {
	INVALID  = 0,
	// Shaders for NDA'd platforms
	PRIVATE  = 1 << 0,
	// SPIR-V shaders for Vulkan
	SPIRV    = 1 << 1,
	// DXBC SM5_1 shaders for D3D12
	DXBC     = 1 << 2,
	// DXIL SM6_0 shaders for D3D12
	DXIL     = 1 << 3,
	// MSL shaders for Metal
	MSL      = 1 << 4,
	// Precompiled metallib shaders for Metal
	METALLIB = 1 << 5,
}

GPUShader :: struct {}

GPUShaderStage :: enum c.int {
	VERTEX,
	FRAGMENT,
}

GPUShaderCreateInfo :: struct {
	// Size in bytes
	code_size:            c.size_t,
	// Pointer to shader code
	code:                 [^]u8,
	// UTF-8 null-terminated string specifying entry point function name
	entry_point:          cstring,
	format:               GPUShaderFormat,
	stage:                GPUShaderStage,
	num_samplers:         u32,
	num_storage_textures: u32,
	num_storage_buffers:  u32,
	num_uniform_buffers:  u32,
	props:                PropertiesID,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	CreateGPUShader :: proc(device: ^GPUDevice, create_info: ^GPUShaderCreateInfo) -> ^GPUShader ---
	GetGPUShaderFormats :: proc(device: ^GPUDevice) -> GPUShaderFormat ---
	ReleaseGPUShader :: proc(device: ^GPUDevice, shader: ^GPUShader) ---
}
