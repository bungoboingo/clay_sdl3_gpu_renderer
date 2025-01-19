package sdl3

import "core:c"

foreign import lib "system:SDL3"

GPUCommandBuffer :: struct {}
GPUBuffer :: struct {}
GPUTransferBuffer :: struct {}

GPUStorageBufferReadWriteBinding :: struct {
	// The buffer to bind; must have been created with BUFFERUSAGE_COMPUTE_STORAGE_WRITE
	buffer: ^GPUBuffer,
	// Setting to `true` cycles the texture if it is arleady bound
	cycle:  bool,
	_:      u8,
	_:      u8,
	_:      u8,
}

GPUBufferBinding :: struct {
	// The buffer to bind. Must have been created with BUFFERUSAGE_VERTEX for BindGPUVertexBuffers, or BUFFERUSAGE_INDEX for BindGPUIndexBuffer.
	buffer: ^GPUBuffer,
	// The starting byte of the data to bind in the buffer.
	offset: u32,
}

GPUBufferLocation :: struct {
	buffer: ^GPUBuffer,
	offset: u32,
}

GPUBufferUsageFlag :: enum u32 {
	VERTEX                = 0,
	INDEX                 = 1,
	INDIRECT              = 2,
	GRAPHICS_STORAGE_READ = 3,
	COMPUTE_STORAGE_READ  = 4,
	COMPUTE_STORAGE_WRITE = 5,
}

GPUBufferUsageFlags :: bit_set[GPUBufferUsageFlag;u32]

BUFFER_USAGE_VERTEX :: GPUBufferUsageFlags{.VERTEX}
BUFFER_USAGE_INDEX :: GPUBufferUsageFlags{.INDEX}
BUFFER_USAGE_INDIRECT :: GPUBufferUsageFlags{.INDIRECT}
BUFFER_USAGE_GRAPHICS_STORAGE_READ :: GPUBufferUsageFlags{.GRAPHICS_STORAGE_READ}
BUFFER_USAGE_COMPUTE_STORAGE_READ :: GPUBufferUsageFlags{.COMPUTE_STORAGE_READ}
BUFFER_USAGE_COMPUTE_STORAGE_WRITE :: GPUBufferUsageFlags{.COMPUTE_STORAGE_WRITE}

GPUBufferCreateInfo :: struct {
	usage: GPUBufferUsageFlags,
	size:  u32,
	props: PropertiesID,
}

GPUTransferBufferUsage :: enum c.int {
	UPLOAD,
	DOWNLOAD,
}

GPUTransferBufferCreateInfo :: struct {
	usage: GPUTransferBufferUsage,
	size:  u32,
	props: PropertiesID,
}

GPUTransferBufferLocation :: struct {
	transfer_buffer: ^GPUTransferBuffer,
	offset:          u32,
}

GPUBufferRegion :: struct {
	buffer: ^GPUBuffer,
	offset: u32,
	size:   u32,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	AcquireGPUCommandBuffer :: proc(device: ^GPUDevice) -> ^GPUCommandBuffer ---
	// `first_slot`: The fragment storage buffer slot to begin binding from
	BindGPUFragmentStorageBuffers :: proc(render_pass: ^GPURenderPass, first_slot: u32, storage_buffers: ^[^]GPUBuffer, num_bindings: u32) ---
	BindGPUIndexBuffer :: proc(render_pass: ^GPURenderPass, binding: ^GPUBufferBinding, index_element_size: GPUIndexElementSize) ---
	BindGPUVertexBuffers :: proc(render_pass: ^GPURenderPass, first_slot: u32, bindings: [^]GPUBufferBinding, num_bindings: u32) ---
	BindGPUVertexStorageBuffers :: proc(render_pass: ^GPURenderPass, first_slot: u32, storage_buffers: ^[^]GPUBuffer, num_bindings: u32) ---
	CancelGPUCommandBuffer :: proc(command_buffer: ^GPUCommandBuffer) -> bool ---
	CreateGPUBuffer :: proc(device: ^GPUDevice, create_info: ^GPUBufferCreateInfo) -> ^GPUBuffer ---
	CreateGPUTransferBuffer :: proc(device: ^GPUDevice, create_info: ^GPUTransferBufferCreateInfo) -> ^GPUTransferBuffer ---
	// Returns the address of the mapped transfer buffer memory, or nil on failure
	MapGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer, cycle: bool) -> rawptr ---
	// Frees the given buffer as soon as it is safe to do so
	ReleaseGPUBuffer :: proc(device: ^GPUDevice, buffer: ^GPUBuffer) ---
	ReleaseGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer) ---
	UnmapGPUTransferBuffer :: proc(device: ^GPUDevice, transfer_buffer: ^GPUTransferBuffer) ---
}
