package sdl3

import c "core:c"

JoystickPowerState :: enum c.int {
	ERROR = -1,
	UNKNOWN,
	ON_BATTERY,
	NO_BATTERY,
	CHARGING,
	CHARGED,
}
