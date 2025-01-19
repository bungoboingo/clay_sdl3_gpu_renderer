package sdl3
import "core:c"

foreign import lib "system:SDL3"

GPUDevice :: distinct struct {}
GPUFence :: struct {}

GPUIndexElementSize :: enum c.int {
	BITS_16,
	BITS_32,
}

PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN :: "SDL.gpu.device.create.debugmode"
PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN :: "SDL.gpu.device.create.preferlowpower"
PROP_GPU_DEVICE_CREATE_NAME_STRING :: "SDL.gpu.device.create.name"
PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN :: "SDL.gpu.device.create.shaders.private"
PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN :: "SDL.gpu.device.create.shaders.spirv"
PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN :: "SDL.gpu.device.create.shaders.dxbc"
PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN :: "SDL.gpu.device.create.shaders.dxil"
PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN :: "SDL.gpu.device.create.shaders.msl"
PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN :: "SDL.gpu.device.create.shaders.metallib"
PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING :: "SDL.gpu.device.create.d3d12.semantic"

GPUSwapchainComposition :: enum c.int {
	// B8G8R8A8 or R8G8B8A8 swapchain. Pixel values are in nonlinear sRGB encoding
	SDR,
	// B8G8R8A8_SRGB or R8G8B8A8_SRGB swapchain. Pixel values are in nonlinear sRGB encoding
	SDR_LINEAR,
	// R16G16B16A16_SFLOAT swapchain. Pixel values are in extended linear encoding
	HDR_EXTENDED_LINEAR,
	// A2R10G10B10 or A2B10G10R10 swapchain. Pixel values are in PQ ST2048 encoding
	HDR10_ST2048,
}

GPUPresentMode :: enum c.int {
	//Waits for vblank before presenting. No tearing is possible.
	// If there is a pending image to present, the new image is enqueued for presentation.
	// Disallows tearing at the cost of visual latency.
	VSYNC,
	// Immediately presents. Lowest latency option, but tearing may occur.
	IMMEDIATE,
	// Waits for vblank before presenting. No tearing is possible.
	// If there is a pending image to present, the pending image is replaced by the new image.
	// Similar to VSYNC, but with reduced visual latency.
	MAILBOX,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	ClaimWindowForGPUDevice :: proc(device: ^GPUDevice, window: ^Window) -> bool ---
	CreateGPUDevice :: proc(format_flags: GPUShaderFormat, debug_mode: bool, name: cstring) -> ^GPUDevice ---
	CreateGPUDeviceWithProperties :: proc(props: PropertiesID) -> ^GPUDevice ---
	DestroyGPUDevice :: proc(device: ^GPUDevice) ---
	GetGPUDeviceDriver :: proc(device: ^GPUDevice) -> cstring ---
	GetGPUDriver :: proc(index: i32) -> cstring ---
	GetNumGPUDrivers :: proc() -> i32 ---
	GPUSupportsProperties :: proc(props: PropertiesID) -> bool ---
	// `name` the preferred driver name, or nil to let SDL pick the optimal driver
	GPUSupportsShaderFormats :: proc(format: GPUShaderFormat, name: cstring) -> bool ---
	QueryGPUFence :: proc(device: ^GPUDevice, fence: ^GPUFence) -> bool ---
	ReleaseGPUFence :: proc(device: ^GPUDevice, fence: ^GPUFence) ---
	ReleaseWindowFromGPUDevice :: proc(device: ^GPUDevice, window: ^Window) ---
	SetGPUSwapchainParameters :: proc(device: ^GPUDevice, window: ^Window, swapchain_composition: GPUSwapchainComposition, present_mode: GPUPresentMode) -> bool ---
	SubmitGPUCommandBuffer :: proc(command_buffer: ^GPUCommandBuffer) -> bool ---
	// You must release this fence when it is no longer needed or it will cause a leak. It is invalid to use the command buffer after this is called.
	SubmitGPUCommandBufferAndAcquireFence :: proc(command_buffer: ^GPUCommandBuffer) -> ^GPUFence ---
	WaitForGPUFences :: proc(device: ^GPUDevice, wait_all: bool, fences: ^[^]GPUFence, num_fences: u32) -> bool ---
	// Blocks the thread until the GPU is completely idle
	WaitForGPUIdle :: proc(device: ^GPUDevice) -> bool ---
	WindowSupportsGPUPresentMode :: proc(device: ^GPUDevice, window: ^Window, present_mode: GPUPresentMode) -> bool ---
	WindowSupportsGPUSwapchainComposition :: proc(device: ^GPUDevice, window: ^Window, swapchain_composition: GPUSwapchainComposition) -> bool ---
}
