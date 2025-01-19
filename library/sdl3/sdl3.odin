package sdl3

foreign import lib "system:SDL3"

InitFlag :: enum u32 {
	// AUDIO implies EVENTS
	AUDIO    = 5,
	// VIDEO implies EVENTS
	VIDEO    = 6,
	// JOYSTICK implies EVENTS
	JOYSTICK = 10,
	HAPTIC   = 13,
	// GAMEPAD implies JOYSTICK
	GAMEPAD  = 14,
	EVENTS   = 15,
	// SENSOR implies EVENTS
	SENSOR   = 16,
	// CAMERA implies EVENTS
	CAMERA   = 17,
}

InitFlags :: bit_set[InitFlag;u32]

INIT_AUDIO :: InitFlags{.AUDIO}
INIT_VIDEO :: InitFlags{.VIDEO}
INIT_JOYSTICK :: InitFlags{.JOYSTICK}
INIT_HAPTIC :: InitFlags{.HAPTIC}
INIT_GAMEPAD :: InitFlags{.GAMEPAD}
INIT_EVENTS :: InitFlags{.EVENTS}
INIT_SENSOR :: InitFlags{.SENSOR}
INIT_CAMERA :: InitFlags{.CAMERA}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	/// Returns true if initialization was successful, or false on failure.
	Init :: proc(flags: InitFlag) -> bool ---
	/// Retrieve a message about the last error that occurred on the current thread.
	GetError :: proc() -> cstring ---
	/// Returns the number of milliseconds since the SDL library initialized
	GetTicks :: proc() -> u64 ---
}
