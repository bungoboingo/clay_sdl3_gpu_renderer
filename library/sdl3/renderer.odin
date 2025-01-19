package sdl3

import "core:c"

foreign import lib "system:SDL3"

Renderer :: struct {}

VSYNC_DISABLED: i8 : 0
VSYNC_ADAPTIVE: i8 : -1

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	// Takes a pointer to the `window` where rendering is displayed, and the name of the rendering driver
	// to initialize e.g. "vulkan", "opengl", etc, or nil to let SDL choose a default. Returns a valid
	// rendering context or nil if there was an error.
	CreateRenderer :: proc(window: ^Window, name: cstring) -> ^Renderer ---
	CreateRendererWithProperties :: proc(props: PropertiesID) -> ^Renderer ---
	// Returns the name of the clay_renderer. Useful to see what default SDL has chosen.
	GetRendererName :: proc(renderer: ^Renderer) -> cstring ---
	// Destroy a clay_renderer
	DestroyRenderer :: proc(renderer: ^Renderer) ---
	// Set the color used for the next drawing operations
	SetRenderDrawColor :: proc(renderer: ^Renderer, r: u8, g: u8, b: u8, a: u8) -> bool ---
	// Clear the clay_renderer with the currently set drawing color
	RenderClear :: proc(renderer: ^Renderer) -> bool ---
	// Update the screen with any rendering performed since previous call
	RenderPresent :: proc(renderer: ^Renderer) -> bool ---
	SetRenderVSync :: proc(renderer: ^Renderer, vsync: i8) -> bool ---
	GetRenderVSync :: proc(renderer: ^Renderer, vsync: ^i8) -> bool ---
}
