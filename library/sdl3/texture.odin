package sdl3
import "core:c"

foreign import lib "system:SDL3"

GPUTexture :: struct {}

GPUTextureSamplerBinding :: struct {
	// The texture to bind. Must have been created with TEXTUREUSAGE_SAMPLER
	texture: ^GPUTexture,
	sampler: ^GPUSampler,
}

GPUTextureRegion :: struct {
	texture:   ^GPUTexture,
	mip_level: u32,
	layer:     u32,
	x:         u32,
	y:         u32,
	z:         u32,
	w:         u32,
	h:         u32,
	d:         u32,
}

GPUTextureTransferInfo :: struct {
	transfer_buffer: ^GPUTransferBuffer,
	offset:          u32,
	pixels_per_row:  u32,
	rows_per_layer:  u32,
}

GPUStorageTextureReadWriteBinding :: struct {
	// The texture to bind; must have been created with
	// TEXTUREUSAGE_COMPUTE_STORAGE_WRITE, TEXTUREUSAGE_COMPUTE_STORAGE_WRITE,
	// or TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE
	texture:   ^GPUTexture,
	// Mip level index to bind
	mip_level: u32,
	// Layer index to bind
	layer:     u32,
	// Setting to `true` cycles the texture if it is already bound
	cycle:     bool,
	_:         u8,
	_:         u8,
	_:         u8,
}

GPUBlitRegion :: struct {
	texture:              ^GPUTexture,
	mip_level:            u32,
	layer_or_depth_plane: u32,
	x:                    u32,
	y:                    u32,
	w:                    u32,
	h:                    u32,
}

FlipMode :: enum c.int {
	NONE,
	HORIZONTAL,
	VERTICAL,
}

GPUFilter :: enum c.int {
	NEAREST,
	LINEAR,
}

GPUBlitInfo :: struct {
	source:      GPUBlitRegion, /**< The source region for the blit. */
	destination: GPUBlitRegion, /**< The destination region for the blit. */
	load_op:     GPULoadOp, /**< What is done with the contents of the destination before the blit. */
	clear_color: FColor, /**< The color to clear the destination region to before the blit. Ignored if load_op is not LOADOP_CLEAR. */
	flip_mode:   FlipMode, /**< The flip mode for the source region. */
	filter:      GPUFilter, /**< The filter mode used when blitting. */
	cycle:       bool, /**< true cycles the destination texture if it is already bound. */
	_:           u8,
	_:           u8,
	_:           u8,
}

GPUTextureFormat :: enum c.int {
	INVALID,
	/* Unsigned Normalized Float Color Formats */
	A8_UNORM,
	R8_UNORM,
	R8G8_UNORM,
	R8G8B8A8_UNORM,
	R16_UNORM,
	R16G16_UNORM,
	R16G16B16A16_UNORM,
	R10G10B10A2_UNORM,
	B5G6R5_UNORM,
	B5G5R5A1_UNORM,
	B4G4R4A4_UNORM,
	B8G8R8A8_UNORM,
	/* Compressed Unsigned Normalized Float Color Formats */
	BC1_RGBA_UNORM,
	BC2_RGBA_UNORM,
	BC3_RGBA_UNORM,
	BC4_R_UNORM,
	BC5_RG_UNORM,
	BC7_RGBA_UNORM,
	/* Compressed Signed Float Color Formats */
	BC6H_RGB_FLOAT,
	/* Compressed Unsigned Float Color Formats */
	BC6H_RGB_UFLOAT,
	/* Signed Normalized Float Color Formats  */
	R8_SNORM,
	R8G8_SNORM,
	R8G8B8A8_SNORM,
	R16_SNORM,
	R16G16_SNORM,
	R16G16B16A16_SNORM,
	/* Signed Float Color Formats */
	R16_FLOAT,
	R16G16_FLOAT,
	R16G16B16A16_FLOAT,
	R32_FLOAT,
	R32G32_FLOAT,
	R32G32B32A32_FLOAT,
	/* Unsigned Float Color Formats */
	R11G11B10_UFLOAT,
	/* Unsigned Integer Color Formats */
	R8_UINT,
	R8G8_UINT,
	R8G8B8A8_UINT,
	R16_UINT,
	R16G16_UINT,
	R16G16B16A16_UINT,
	R32_UINT,
	R32G32_UINT,
	R32G32B32A32_UINT,
	/* Signed Integer Color Formats */
	R8_INT,
	R8G8_INT,
	R8G8B8A8_INT,
	R16_INT,
	R16G16_INT,
	R16G16B16A16_INT,
	R32_INT,
	R32G32_INT,
	R32G32B32A32_INT,
	/* SRGB Unsigned Normalized Color Formats */
	R8G8B8A8_UNORM_SRGB,
	B8G8R8A8_UNORM_SRGB,
	/* Compressed SRGB Unsigned Normalized Color Formats */
	BC1_RGBA_UNORM_SRGB,
	BC2_RGBA_UNORM_SRGB,
	BC3_RGBA_UNORM_SRGB,
	BC7_RGBA_UNORM_SRGB,
	/* Depth Formats */
	D16_UNORM,
	D24_UNORM,
	D32_FLOAT,
	D24_UNORM_S8_UINT,
	D32_FLOAT_S8_UINT,
	/* Compressed ASTC Normalized Float Color Formats*/
	ASTC_4x4_UNORM,
	ASTC_5x4_UNORM,
	ASTC_5x5_UNORM,
	ASTC_6x5_UNORM,
	ASTC_6x6_UNORM,
	ASTC_8x5_UNORM,
	ASTC_8x6_UNORM,
	ASTC_8x8_UNORM,
	ASTC_10x5_UNORM,
	ASTC_10x6_UNORM,
	ASTC_10x8_UNORM,
	ASTC_10x10_UNORM,
	ASTC_12x10_UNORM,
	ASTC_12x12_UNORM,
	/* Compressed SRGB ASTC Normalized Float Color Formats*/
	ASTC_4x4_UNORM_SRGB,
	ASTC_5x4_UNORM_SRGB,
	ASTC_5x5_UNORM_SRGB,
	ASTC_6x5_UNORM_SRGB,
	ASTC_6x6_UNORM_SRGB,
	ASTC_8x5_UNORM_SRGB,
	ASTC_8x6_UNORM_SRGB,
	ASTC_8x8_UNORM_SRGB,
	ASTC_10x5_UNORM_SRGB,
	ASTC_10x6_UNORM_SRGB,
	ASTC_10x8_UNORM_SRGB,
	ASTC_10x10_UNORM_SRGB,
	ASTC_12x10_UNORM_SRGB,
	ASTC_12x12_UNORM_SRGB,
	/* Compressed ASTC Signed Float Color Formats*/
	ASTC_4x4_FLOAT,
	ASTC_5x4_FLOAT,
	ASTC_5x5_FLOAT,
	ASTC_6x5_FLOAT,
	ASTC_6x6_FLOAT,
	ASTC_8x5_FLOAT,
	ASTC_8x6_FLOAT,
	ASTC_8x8_FLOAT,
	ASTC_10x5_FLOAT,
	ASTC_10x6_FLOAT,
	ASTC_10x8_FLOAT,
	ASTC_10x10_FLOAT,
	ASTC_12x10_FLOAT,
	ASTC_12x12_FLOAT,
}

GPUTextureLocation :: struct {
	texture:   ^GPUTexture,
	mip_level: u32,
	layer:     u32,
	// Left offset of the location
	x:         u32,
	// Top offset of the location
	y:         u32,
	// Front offset of the location
	z:         u32,
}

GPUTextureType :: enum c.int {
	TEX_2D,
	TEX_2D_ARRAY,
	TEX_3D,
	TEX_CUBE,
	TEX_CUBE_ARRAY,
}

GPUTextureUsageFlag :: enum u32 {
	SAMPLER,
	COLOR_TARGET,
	DEPTH_STENCIL_TARGET,
	GRAPHICS_STORAGE_READ,
	COMPUTE_STORAGE_READ,
	COMPUTE_STORAGE_WRITE,
	COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE,
}

GPUTextureUsageFlags :: bit_set[GPUTextureUsageFlag;u32]

TEXTURE_USAGE_SAMPLER :: GPUTextureUsageFlags{.SAMPLER}
TEXTURE_USAGE_COLOR_TARGET :: GPUTextureUsageFlags{.COLOR_TARGET}
TEXTURE_USAGE_DEPTH_STENCIL_TARGET :: GPUTextureUsageFlags{.DEPTH_STENCIL_TARGET}
TEXTURE_USAGE_GRAPHICS_STORAGE_READ :: GPUTextureUsageFlags{.GRAPHICS_STORAGE_READ}
TEXTURE_USAGE_COMPUTE_STORAGE_READ :: GPUTextureUsageFlags{.COMPUTE_STORAGE_READ}
TEXTURE_USAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE :: GPUTextureUsageFlags {
	.COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE,
}

GPUTextureCreateInfo :: struct {
	type:                 GPUTextureType,
	format:               GPUTextureFormat,
	usage:                GPUTextureUsageFlags,
	width:                u32,
	height:               u32,
	layer_count_or_depth: u32,
	num_levels:           u32,
	sample_count:         GPUSampleCount,
	props:                PropertiesID,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	AcquireGPUSwapchainTexture :: proc(command_buffer: ^GPUCommandBuffer, window: ^Window, swapchain_texture: ^^GPUTexture, swapchain_texture_width: ^u32, swapchain_texture_height: ^u32) -> bool ---
	WaitAndAcquireGPUSwapchainTexture :: proc(command_buffer: ^GPUCommandBuffer, window: ^Window, swapchain_texture: ^^GPUTexture, swapchain_texture_width: ^u32, swapchain_texture_height: ^u32) -> bool ---
	// `first_slot`: The fragment storage texture slot to begin binding from
	BindGPUFragmentStorageTextures :: proc(render_pass: ^GPURenderPass, first_slot: u32, storage_textures: ^[^]GPUTexture, num_bindings: u32) ---
	BindGPUVertexStorageTextures :: proc(render_pass: ^GPURenderPass, first_slot: u32, storage_textures: ^[^]GPUTexture, num_bindings: u32) ---
	BlitGPUTexture :: proc(command_buffer: ^GPUCommandBuffer, info: ^GPUBlitInfo) ---
	// Returns the byte size of the calculated texture
	CalculateGPUTextureFormatSize :: proc(format: GPUTextureFormat, width: u32, height: u32, depth_or_layer_count: u32) -> u32 ---
	CreateGPUTexture :: proc(device: ^GPUDevice, create_info: ^GPUTextureCreateInfo) -> ^GPUTexture ---
	GenerateMipmapsForGPUTexture :: proc(command_buffer: ^GPUCommandBuffer, texture: ^GPUTexture) ---
	GetGPUSwapchainTextureFormat :: proc(device: ^GPUDevice, window: ^Window) -> GPUTextureFormat ---
	GPUTextureFormatTexelBlockSize :: proc(format: GPUTextureFormat) -> u32 ---
	GPUTextureSupportsFormat :: proc(device: ^GPUDevice, format: GPUTextureFormat, type: GPUTextureType, usage: GPUTextureUsageFlags) -> bool ---
	GPUTextureSupportsSampleCount :: proc(device: ^GPUDevice, format: GPUTextureFormat, sample_count: GPUSampleCount) -> bool ---
	ReleaseGPUTexture :: proc(device: ^GPUDevice, texture: ^GPUTexture) ---
}
