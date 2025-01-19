package sdl3

import "core:c"

foreign import lib "system:SDL3"

TimerId :: distinct u32
TimerCallback :: proc(userdata: rawptr, id: TimerId, interval: u32) -> u32

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	AddTimer :: proc(interval: u32, callback: TimerCallback, userdata: rawptr) -> TimerId ---
}
