package sdl3
import "core:c"
foreign import lib "system:SDL3"

Window :: struct {}

WindowFlag :: enum u64 {
	// Window is in fullscreen mode
	FULLSCREEN         = 0,
	// Window usable with OpenGL context
	OPENGL             = 1,
	// Window is occluded
	OCCLUDED           = 2,
	// Window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible
	HIDDEN             = 3,
	// No window decoration
	BORDERLESS         = 4,
	// Window can be resized
	RESIZABLE          = 5,
	// Window is minimized
	MINIMIZED          = 6,
	// Window is maximized
	MAXIMIZED          = 7,
	// Window has grabbed mouse input
	MOUSE_GRABBED      = 8,
	// Window has input focus
	INPUT_FOCUS        = 9,
	// Window has mouse focus
	MOUSE_FOCUS        = 10,
	// Window not created by SDL
	EXTERNAL           = 11,
	// Window is modal
	MODAL              = 12,
	// Window uses high pixel density back buffer if possible
	HIGH_PIXEL_DENSITY = 13,
	// Window has mouse captured (unrelated to MOUSE_GRABBED)
	MOUSE_CAPTURE      = 14,
	// Window has relative mode enabled
	RELATIVE_MODE      = 15,
	// Window should always be above others
	ALWAYS_ON_TOP      = 16,
	// Window should be treated as a utility window, not showing in the task bar and window list
	UTILITY            = 17,
	// Window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window
	TOOLTIP            = 18,
	// Window should be treated as a popup menu, requires a parent window
	POPUP_MENU         = 19,
	// Window has grabbed keyboard input
	KEYBOARD_GRABBED   = 20,
	// Window usable for Vulkan surface
	VULKAN             = 28,
	// Window usable for Metal view
	METAL              = 29,
	// Window with transparent buffer
	TRANSPARENT        = 30,
	// Window should not be focusable
	NOT_FOCUSABLE      = 31,
}

WindowFlags :: distinct bit_set[WindowFlag;u32]

WINDOW_FULLSCREEN :: WindowFlags{.FULLSCREEN}
WINDOW_OPENGL :: WindowFlags{.OPENGL}
WINDOW_OCCLUDED :: WindowFlags{.OCCLUDED}
WINDOW_HIDDEN :: WindowFlags{.HIDDEN}
WINDOW_BORDERLESS :: WindowFlags{.BORDERLESS}
WINDOW_RESIZABLE :: WindowFlags{.RESIZABLE}
WINDOW_MINIMIZED :: WindowFlags{.MINIMIZED}
WINDOW_MAXIMIZED :: WindowFlags{.MAXIMIZED}
WINDOW_MOUSE_GRABBED :: WindowFlags{.MOUSE_GRABBED}
WINDOW_INPUT_FOCUS :: WindowFlags{.INPUT_FOCUS}
WINDOW_MOUSE_FOCUS :: WindowFlags{.MOUSE_FOCUS}
WINDOW_EXTERNAL :: WindowFlags{.EXTERNAL}
WINDOW_MODAL :: WindowFlags{.MODAL}
WINDOW_HIGH_PIXEL_DENSITY :: WindowFlags{.HIGH_PIXEL_DENSITY}
WINDOW_MOUSE_CAPTURE :: WindowFlags{.MOUSE_CAPTURE}
WINDOW_RELATIVE_MODE :: WindowFlags{.RELATIVE_MODE}
WINDOW_ALWAYS_ON_TOP :: WindowFlags{.ALWAYS_ON_TOP}
WINDOW_UTILITY :: WindowFlags{.UTILITY}
WINDOW_TOOLTIP :: WindowFlags{.TOOLTIP}
WINDOW_POPUP_MENU :: WindowFlags{.POPUP_MENU}
WINDOW_KEYBOARD_GRABBED :: WindowFlags{.KEYBOARD_GRABBED}
WINDOW_VULKAN :: WindowFlags{.VULKAN}
WINDOW_METAL :: WindowFlags{.METAL}
WINDOW_TRANSPARENT :: WindowFlags{.TRANSPARENT}
WINDOW_NOT_FOCUSABLE :: WindowFlags{.NOT_FOCUSABLE}

PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN :: "SDL.window.create.always_on_top"
PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN :: "SDL.window.create.borderless"
PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN :: "SDL.window.create.focusable"
PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN :: "SDL.window.create.external_graphics_context"
PROP_WINDOW_CREATE_FLAGS_NUMBER :: "SDL.window.create.flags"
PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN :: "SDL.window.create.fullscreen"
PROP_WINDOW_CREATE_HEIGHT_NUMBER :: "SDL.window.create.height"
PROP_WINDOW_CREATE_HIDDEN_BOOLEAN :: "SDL.window.create.hidden"
PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN :: "SDL.window.create.high_pixel_density"
PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN :: "SDL.window.create.maximized"
PROP_WINDOW_CREATE_MENU_BOOLEAN :: "SDL.window.create.menu"
PROP_WINDOW_CREATE_METAL_BOOLEAN :: "SDL.window.create.metal"
PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN :: "SDL.window.create.minimized"
PROP_WINDOW_CREATE_MODAL_BOOLEAN :: "SDL.window.create.modal"
PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN :: "SDL.window.create.mouse_grabbed"
PROP_WINDOW_CREATE_OPENGL_BOOLEAN :: "SDL.window.create.opengl"
PROP_WINDOW_CREATE_PARENT_POINTER :: "SDL.window.create.parent"
PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN :: "SDL.window.create.resizable"
PROP_WINDOW_CREATE_TITLE_STRING :: "SDL.window.create.title"
PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN :: "SDL.window.create.transparent"
PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN :: "SDL.window.create.tooltip"
PROP_WINDOW_CREATE_UTILITY_BOOLEAN :: "SDL.window.create.utility"
PROP_WINDOW_CREATE_VULKAN_BOOLEAN :: "SDL.window.create.vulkan"
PROP_WINDOW_CREATE_WIDTH_NUMBER :: "SDL.window.create.width"
PROP_WINDOW_CREATE_X_NUMBER :: "SDL.window.create.x"
PROP_WINDOW_CREATE_Y_NUMBER :: "SDL.window.create.y"
PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER :: "SDL.window.create.cocoa.window"
PROP_WINDOW_CREATE_COCOA_VIEW_POINTER :: "SDL.window.create.cocoa.view"
PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN :: "SDL.window.create.wayland.surface_role_custom"
PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN :: "SDL.window.create.wayland.create_egl_window"
PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER :: "SDL.window.create.wayland.wl_surface"
PROP_WINDOW_CREATE_WIN32_HWND_POINTER :: "SDL.window.create.win32.hwnd"
PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER :: "SDL.window.create.win32.pixel_format_hwnd"
PROP_WINDOW_CREATE_X11_WINDOW_NUMBER :: "SDL.window.create.x11.window"


@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	// Create a window with the specified dimensions & `flags`.
	CreateWindow :: proc(title: cstring, w, h: c.int, flags: WindowFlags) -> ^Window ---
	CreateWindowWithProperties :: proc(props: PropertiesID) -> ^Window ---
	// Destroy a window
	DestroyWindow :: proc(window: ^Window) ---
	// Gets the window size
	GetWindowSize :: proc(window: ^Window, w: ^c.int, h: ^c.int) -> bool ---
	GetWindowDisplayScale :: proc(window: ^Window) -> f32 ---
	// Gets the surface for the window
	GetWindowSurface :: proc(window: ^Window) -> ^Surface ---
	SetWindowSurfaceVSync :: proc(window: ^Window, vsync: i8) -> bool ---
}
