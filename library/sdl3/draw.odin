package sdl3
import "core:c"

foreign import lib "system:SDL3"

Rect :: struct {
	x: c.int,
	y: c.int,
	w: c.int,
	h: c.int,
}

FRect :: struct {
	x: f32,
	y: f32,
	w: f32,
	h: f32,
}

Texture :: struct {
	format:   PixelFormat,
	w:        c.int,
	h:        c.int,
	refcount: c.int,
}

SurfaceFlag :: enum u32 {
	PREALLOCATED = 0x01,
	LOCK_NEEDED  = 0x02,
	LOCKED       = 0x04,
	SIMD_ALIGNED = 0x08,
}

SurfaceFlags :: bit_set[SurfaceFlag;u32]

SURFACE_PREALLOCATED :: SurfaceFlags{.PREALLOCATED}
SURFACE_LOCK_NEEDED :: SurfaceFlags{.LOCK_NEEDED}
SURFACE_LOCKED :: SurfaceFlags{.LOCKED}
SURFACE_SIMD_ALIGNED :: SurfaceFlags{.SIMD_ALIGNED}

Surface :: struct {
	flags:    SurfaceFlags,
	format:   PixelFormat,
	w:        c.int,
	h:        c.int,
	/// Distance in bytes between rows of pixels
	pitch:    c.int,
	/// Pointer to the pixels of the surface
	pixels:   rawptr,
	refcount: c.int,
	reserved: rawptr,
}

BlendMode :: enum u32 {
	NONE                = 0x0,
	BLEND               = 0x1,
	ADD                 = 0x2,
	MOD                 = 0x4,
	MUL                 = 0x8,
	BLEND_PREMULTIPLIED = 0x10,
	ADD_PREMULTIPLIED   = 0x20,
	INVALID             = 0x7FFFFFFF,
}

/// Surface procs
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	CreateSurface :: proc(width: c.int, height: c.int, format: PixelFormat) -> ^Surface ---
	CreateTextureFromSurface :: proc(renderer: ^Renderer, surface: ^Surface) -> ^Texture ---
	/// `src_rect`: If nil, copies the entire Surface
	/// `dst_rect`: The SDL_Rect structure representing the x & y position in the destination surface, or nil for (0, 0).
	/// The w/h are ignored, and are copied from `src_rect`.
	BlitSurface :: proc(src_surface: ^Surface, src_rect: ^Rect, dst_surface: ^Surface, dst_rect: ^Rect) -> bool ---
	DestroySurface :: proc(surface: ^Surface) ---
	SetSurfaceBlendMode :: proc(surface: ^Surface, blend_mode: BlendMode) -> bool ---
}

/// Texture procs
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	DestroyTexture :: proc(texture: ^Texture) ---
	SetTextureColorMod :: proc(texture: ^Texture, r: u8, g: u8, b: u8) -> bool ---
	/// `src_rect`: if nil, uses the entire texture
	/// `dst_rect`: if nil, uses the entire rendering target
	RenderTexture :: proc(renderer: ^Renderer, texture: ^Texture, src_rect: ^FRect, dst_rect: ^FRect) -> bool ---
}

/// Draw procs
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	RenderFillRect :: proc(renderer: ^Renderer, rect: ^FRect) -> bool ---
	RenderRect :: proc(renderer: ^Renderer, rect: ^FRect) -> bool ---
}

/// Util procs
@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	//TODO this function isn't found in SDL3? something to do with #force_inline?
	//RectToFRect :: #force_inline proc(rect: ^Rect, f_rect: ^FRect) ---
}
