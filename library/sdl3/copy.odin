package sdl3
import "core:c"

foreign import lib "system:SDL3"

GPUCopyPass :: struct {}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	BeginGPUCopyPass :: proc(command_buffer: ^GPUCommandBuffer) -> ^GPUCopyPass ---
	CopyBufferToBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUBufferLocation, destination: ^GPUBufferLocation, size: u32, cycle: bool) ---
	CopyTextureToTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureLocation, destination: ^GPUTextureLocation, width: u32, height: u32, depth: u32, cycle: bool) ---
	DownloadFromGPUBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUBufferRegion, destination: ^GPUTransferBufferLocation) ---
	DownloadFromGPUTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureRegion, destination: ^GPUTextureTransferInfo) ---
	EndGPUCopyPass :: proc(copy_pass: ^GPUCopyPass) ---
	UploadToGPUBuffer :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTransferBufferLocation, destination: ^GPUBufferRegion, cycle: bool) ---
	UploadToGPUTexture :: proc(copy_pass: ^GPUCopyPass, source: ^GPUTextureTransferInfo, destination: ^GPUTextureRegion, cycle: bool) ---
}
