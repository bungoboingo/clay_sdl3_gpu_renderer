package sdl3
import "core:c"

foreign import lib "system:SDL3"

IOStream :: struct {}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	/// `size`: The buffer size, in bytes
	IOFromConstMem :: proc(mem: rawptr, size: int) -> ^IOStream ---
	LoadFile :: proc(file: cstring, size: ^int) -> rawptr ---
	free :: proc(mem: rawptr) ---
}
