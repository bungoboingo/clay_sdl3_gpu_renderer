package sdl3
import "core:c"

foreign import lib "system:SDL3"

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	InsertGPUDebugLabel :: proc(command_buffer: ^GPUCommandBuffer, label: cstring) ---
	SetGPUTextureName :: proc(device: ^GPUDevice, texture: ^GPUTexture, name: cstring) ---
	// Sets an arbitrary string constant to label a buffer
	SetGPUBufferName :: proc(device: ^GPUDevice, buffer: ^GPUBuffer, name: cstring) ---
	PopGPUDebugGroup :: proc(command_buffer: ^GPUCommandBuffer) ---
	PushGPUDebugGroup :: proc(command_buffer: ^GPUCommandBuffer, name: cstring) ---
}
