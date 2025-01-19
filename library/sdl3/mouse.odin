package sdl3

import "core:c"

foreign import lib "system:SDL3"

Cursor :: struct {}

MouseWheelDirection :: enum u32 {
	NORMAL, /**< The scroll direction is normal */
	FLIPPED, /**< The scroll direction is flipped / natural */
}

MouseButtonFlag :: enum u32 {
	LEFT   = 0,
	MIDDLE = 1,
	RIGHT  = 2,
	X1     = 3,
	X2     = 4,
}

MouseButtonFlags :: bit_set[MouseButtonFlag;u32]

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	GetMouseState :: proc(x: ^f32, y: ^f32) -> MouseButtonFlags ---
}
