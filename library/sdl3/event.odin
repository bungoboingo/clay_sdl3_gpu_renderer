package sdl3

import "core:c"

foreign import lib "system:SDL3"

DisplayId :: distinct u32
WindowId :: distinct u32
KeyboardId :: distinct u32
MouseId :: distinct u32
JoystickId :: distinct u32
AudioDeviceId :: distinct u32
CameraId :: distinct u32
SensorId :: distinct u32
TouchId :: distinct u32
FingerId :: distinct u32
PenId :: distinct u32

EventType :: enum c.int {
	FIRST = 0,
	QUIT = 0x100,
	TERMINATING,
	LOW_MEMORY,
	WILL_ENTER_BACKGROUND,
	DID_ENTER_BACKGROUND,
	WILL_ENTER_FOREGROUND,
	DID_ENTER_FOREGROUND,
	LOCALE_CHANGED,
	SYSTEM_THEME_CHANGED,
	DISPLAY_ORIENTATION = 0x151,
	DISPLAY_ADDED,
	DISPLAY_REMOVED,
	DISPLAY_MOVED,
	DISPLAY_DESKTOP_MODE_CHANGED,
	DISPLAY_CURRENT_MODE_CHANGED,
	DISPLAY_CONTENT_SCALE_CHANGED,
	DISPLAY_FIRST = DISPLAY_ORIENTATION,
	DISPLAY_LAST = DISPLAY_CONTENT_SCALE_CHANGED,
	WINDOW_SHOWN = 0x202,
	WINDOW_HIDDEN,
	WINDOW_EXPOSED,
	WINDOW_MOVED,
	WINDOW_RESIZED,
	WINDOW_PIXEL_SIZE_CHANGED,
	WINDOW_METAL_VIEW_REISZED,
	WINDOW_MINIMIZED,
	WINDOW_MAXIMIZED,
	WINDOW_RESTORED,
	WINDOW_MOUSE_ENTER,
	WINDOW_MOUSE_LEAVE,
	WINDOW_FOCUS_GAINED,
	WINDOW_FOCUS_LOST,
	WINDOW_CLOSE_REQUESTED,
	WINDOW_HIT_TEST,
	WINDOW_ICCPROF_CHANGED,
	WINDOW_DISPLAY_CHANGED,
	WINDOW_DISPLAY_SCALE_CHANGED,
	WINDOW_SAFE_AREA_CHANGED,
	WINDOW_OCCLUDED,
	WINDOW_ENTER_FULLSCREEN,
	WINDOW_LEAVE_FULLSCREEN,
	WINDOW_DESTROYED,
	WINDOW_HDR_STATE_CHANGED,
	WINDOW_FIRST = WINDOW_SHOWN,
	WINDOW_LAST = WINDOW_HDR_STATE_CHANGED,
	KEY_DOWN = 0x300,
	KEY_UP,
	TEXT_EDITING,
	TEXT_INPUT,
	KEYMAP_CHANGED,
	KEYBOARD_ADDED,
	KEYBOARD_REMOVED,
	TEXT_EDITING_CANDIDATES,
	MOUSE_MOTION = 0x400,
	MOUSE_BUTTON_DOWN,
	MOUSE_BUTTON_UP,
	MOUSE_WHEEL,
	MOUSE_ADDED,
	MOUSE_REMOVED,
	JOYSTICK_AXIS_MOTION = 0x600,
	JOYSTICK_BALL_MOTION,
	JOYSTICK_HAT_MOTION,
	JOYSTICK_BUTTON_DOWN,
	JOYSTICK_BUTTON_UP,
	JOYSTICK_ADDED,
	JOYSTICK_REMOVED,
	JOYSTICK_BATTERY_UPDATED,
	JOYSTICK_UPDATE_COMPLETE,
	GAMEPAD_AXIS_MOTION = 0x650,
	GAMEPAD_BUTTON_DOWN,
	GAMEPAD_BUTTON_UP,
	GAMEPAD_ADDED,
	GAMEPAD_REMOVED,
	GAMEPAD_REMAPPED,
	GAMEPAD_TOUCHPAD_DOWN,
	GAMEPAD_TOUCHPAD_MOTION,
	GAMEPAD_TOUCHPAD_UP,
	GAMEPAD_SENSOR_UPDATE,
	GAMEPAD_UPDATE_COMPLETE,
	GAMEPAD_STEAM_HANDEL_UPDATED,
	FINGER_DOWN = 0x700,
	FINGER_UP,
	FINGER_MOTION,
	CLIPBOARD_UPDATE = 0x900,
	DROP_FILE = 0x1000,
	DROP_TEXT,
	DROP_BEGIN,
	DROP_COMPLETE,
	DROP_POSITION,
	AUDIO_DEVICE_ADDED = 0x1100,
	AUDIO_DEVICE_REMOVED,
	AUDIO_DEVICE_FORMAT_CHANGED,
	SENSOR_UPDATE = 0x1200,
	PEN_PROXIMITY_IN = 0x1300,
	PEN_PROXIMITY_OUT,
	PEN_DOWN,
	PEN_UP,
	PEN_BUTTON_DOWN,
	PEN_BUTTON_UP,
	PEN_MOTION,
	PEN_AXIS,
	CAMERA_DEVICE_ADDED = 0x1400,
	CAMERA_DEVICE_REMOVED,
	CAMERA_DEVICE_APPROVED,
	CAMERA_DEVICE_DENIED,
	RENDER_TARGETS_RESET = 0x2000,
	RENDER_DEVICE_RESET,
	RENDER_DEVICE_LOST,
	PRIVATE0 = 0x4000,
	PRIVATE1,
	PRIVATE2,
	PRIVATE3,
	POLL_SENTINEL = 0x7F00,
	USER = 0x8000,
	LAST = 0xFFFF,
	ENUM_PADDING = 0x7FFFFFFF,
}

CommonEvent :: struct {
	type:      u32,
	reserved:  u32,
	timestmap: u64,
}

DisplayEvent :: struct {
	type:       EventType,
	reserved:   u32,
	timestamp:  u64,
	display_id: DisplayId,
	data1:      i32,
	data2:      i32,
}

WindowEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	data1:     i32,
	data2:     i32,
}

KeyboardDeviceEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	keyboard_id: KeyboardId,
}

KeyboardEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestmap:   u64,
	window_id:   WindowId,
	keyboard_id: KeyboardId,
	scancode:    Scancode,
	key:         Keycode,
	mod:         Keymod,
	raw:         u16,
	down:        bool,
	repeat:      bool,
}

TextEditingEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	text:      cstring,
	start:     i32,
	length:    i32,
}

TextEditingCandidatesEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	text:      cstring,
	start:     i32,
	length:    i32,
}

TextInputEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	text:      cstring,
}

MouseDeviceEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	mouse_id:  MouseId,
}

MouseMotionEvent :: struct {
	type:       EventType,
	reserved:   u32,
	timestamp:  u64,
	window_id:  WindowId,
	mouse_id:   MouseId,
	// See: mouse -> button flags
	state:      u32,
	// x coordinate, relative to the window
	x:          f32,
	// y coordinate, relative to the window
	y:          f32,
	// Relative motion in the x direction
	x_relative: f32,
	// Relative motion in the y direction
	y_relative: f32,
}

MouseButtonEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	mouse_id:  MouseId,
	// Mouse button index
	button:    u8,
	down:      bool,
	// 1 for single-click, 2 for double-click, etc
	clicks:    u8,
	_:         u8,
	// x coordinate, relative to the window
	x:         f32,
	// y coordinate, relative to the window
	y:         f32,
}

MouseWheelEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	mouse_id:  MouseId,
	// The amount scrolled horizontally, positive to the right / negative to the left
	x:         f32,
	// The amount scrolled vertically, positive away from user and negative towards user
	y:         f32,
	// See mouse -> wheel flags
	direction: MouseWheelDirection,
	mouse_x:   f32,
	mouse_y:   f32,
}

JoystickDeviceEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
}

JoystickAxisEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	// Axis index
	axis:        u8,
	_:           u8,
	_:           u8,
	_:           u8,
	value:       i16,
	_:           u16,
}

JoystickBallEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	// Trackball index
	ball:        u8,
	_:           u8,
	_:           u8,
	_:           u8,
	x_relative:  i16,
	y_relative:  i16,
}

JoystickHatEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	// Joystick hat index
	hat:         u8,
	// Hat position value
	value:       u8,
	_:           u8,
	_:           u8,
}

JoystickButtonEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	// Button index
	button:      u8,
	down:        bool,
	_:           u8,
	_:           u8,
}

JoystickBatteryEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	state:       JoystickPowerState,
	// Percent charge remaining
	percent:     c.int,
}

GamepadDeviceEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
}

GamepadAxisEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestmap:   u64,
	joystick_id: JoystickId,
	axis:        u8,
	_:           u8,
	_:           u8,
	_:           u8,
	value:       i16,
	_:           u16,
}

GamepadButtonEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	button:      u8,
	down:        bool,
	_:           u8,
	_:           u8,
}

GamepadTouchpadEvent :: struct {
	type:        EventType,
	reserved:    u32,
	timestamp:   u64,
	joystick_id: JoystickId,
	// Index of touchpad
	touchpad:    i32,
	// Index of the finger on the touchpad
	finger:      i32,
	// Normalized 0..1, 0 = left
	x:           f32,
	// Normalized 0..1, 0 = top
	y:           f32,
	// Normalized 0..1
	pressure:    f32,
}

GamepadSensorEvent :: struct {
	type:             EventType,
	reserved:         u32,
	timestamp:        u64,
	joystick_id:      JoystickId,
	sensor:           i32,
	data:             [3]f32,
	sensor_timestamp: u64,
}

AudioDeviceEvent :: struct {
	type:            EventType,
	reserved:        u32,
	timestamp:       u64,
	audio_device_id: AudioDeviceId,
	recording:       bool,
	_:               u8,
	_:               u8,
	_:               u8,
}

CameraDeviceEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	camera_id: CameraId,
}

SensorEvent :: struct {
	type:             EventType,
	reserved:         u32,
	timestamp:        u64,
	sensor_id:        SensorId,
	data:             [6]f32,
	sensor_timestamp: u64,
}

QuitEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
}

UserEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	code:      i32,
	data_1:    rawptr,
	data_2:    rawptr,
}

TouchFingerEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestmap: u64,
	touch_id:  TouchId,
	finger_id: FingerId,
	x:         f32,
	y:         f32,
	dx:        f32,
	dy:        f32,
	pressure:  f32,
	window_id: WindowId,
}

PenProximityEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	pen_id:    PenId,
}

PenTouchEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	pen_id:    PenId,
	// See: pen -> flags
	state:     u32,
	x:         f32,
	y:         f32,
	eraser:    bool,
	down:      bool,
}

PenMotionEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestmap: u64,
	window_id: WindowId,
	pen_id:    PenId,
	// See: pen -> flags
	pen_state: u32,
	x:         f32,
	y:         f32,
}

PenButtonEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	pen_id:    PenId,
	// See: pen -> flags
	pen_State: u32,
	x:         f32,
	y:         f32,
	// Index
	button:    u8,
	down:      bool,
}

PenAxisEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	pen_id:    PenId,
	// See: pen -> flags
	pen_state: u32,
	x:         f32,
	y:         f32,
	axis:      PenAxis,
	value:     f32,
}

RenderEvent :: struct {}

DropEvent :: struct {
	type:      EventType,
	reserved:  u32,
	timestamp: u64,
	window_id: WindowId,
	x:         f32,
	y:         f32,
	soruce:    cstring,
	data:      cstring,
}

ClipboardEvent :: struct {
	type:         EventType,
	reserved:     u32,
	timestamp:    u64,
	owner:        bool,
	n_mime_types: i32,
	mime_types:   [^]cstring,
}

Event :: struct #raw_union {
	type:            EventType,
	common:          CommonEvent,
	display:         DisplayEvent,
	window:          WindowEvent,
	kdevice:         KeyboardDeviceEvent,
	key:             KeyboardEvent,
	edit:            TextEditingEvent,
	edit_candidates: TextEditingCandidatesEvent,
	text:            TextInputEvent,
	mdevice:         MouseDeviceEvent,
	motion:          MouseMotionEvent,
	button:          MouseButtonEvent,
	wheel:           MouseWheelEvent,
	jdevice:         JoystickDeviceEvent,
	jaxis:           JoystickAxisEvent,
	jball:           JoystickBallEvent,
	jhat:            JoystickHatEvent,
	jbutton:         JoystickButtonEvent,
	jbattery:        JoystickBatteryEvent,
	gdevice:         GamepadDeviceEvent,
	gaxis:           GamepadAxisEvent,
	gbutton:         GamepadButtonEvent,
	gtouchpad:       GamepadTouchpadEvent,
	gsensor:         GamepadSensorEvent,
	adevice:         AudioDeviceEvent,
	cdevice:         CameraDeviceEvent,
	sensor:          SensorEvent,
	quit:            QuitEvent,
	user:            UserEvent,
	tfinger:         TouchFingerEvent,
	pproximity:      PenProximityEvent,
	ptouch:          PenTouchEvent,
	pmotion:         PenMotionEvent,
	pbutton:         PenButtonEvent,
	paxis:           PenAxisEvent,
	render:          RenderEvent,
	drop:            DropEvent,
	clipboard:       ClipboardEvent,
	_:               [128]u8,
}

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	// Poll for currently pending events. Returns true if this got an event or false if there are no
	// events available.
	//
	// `event`: The structure to be filled with the next event from the queue, or nil
	PollEvent :: proc(event: ^Event) -> bool ---
}
