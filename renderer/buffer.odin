package clay_renderer

import "core:log"
import sdl "library:sdl3"

Buffer :: struct {
	gpu:      ^sdl.GPUBuffer,
	transfer: ^sdl.GPUTransferBuffer,
	size:     u32,
}

create_buffer :: proc(
	device: ^sdl.GPUDevice,
	size: u32,
	gpu_usage: sdl.GPUBufferUsageFlags,
) -> Buffer {
	return Buffer {
		gpu = sdl.CreateGPUBuffer(
			device,
			&sdl.GPUBufferCreateInfo{usage = gpu_usage, size = size},
		),
		transfer = sdl.CreateGPUTransferBuffer(
			device,
			&sdl.GPUTransferBufferCreateInfo{usage = .UPLOAD, size = size},
		),
		size = size,
	}
}

resize_buffer :: proc(
	device: ^sdl.GPUDevice,
	buffer: ^Buffer,
	new_size: u32,
	gpu_usage: sdl.GPUBufferUsageFlags,
) {
	if new_size > buffer.size {
		log.debug("Resizing buffer from", buffer.size, "to", new_size)
		destroy_buffer(device, buffer)
		buffer.gpu = sdl.CreateGPUBuffer(
			device,
			&sdl.GPUBufferCreateInfo{usage = gpu_usage, size = new_size},
		)
		buffer.transfer = sdl.CreateGPUTransferBuffer(
			device,
			&sdl.GPUTransferBufferCreateInfo{usage = .UPLOAD, size = new_size},
		)
		buffer.size = new_size
	}
}

destroy_buffer :: proc(device: ^sdl.GPUDevice, buffer: ^Buffer) {
	sdl.ReleaseGPUBuffer(device, buffer.gpu)
	sdl.ReleaseGPUTransferBuffer(device, buffer.transfer)
}
