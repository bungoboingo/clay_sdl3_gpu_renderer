package sdl3

import "core:c"

foreign import lib "system:SDL3"

// Rendering props

PROP_RENDERER_CREATE_NAME_STRING :: "SDL.clay_renderer.create.name"
PROP_RENDERER_CREATE_WINDOW_POINTER :: "SDL.clay_renderer.create.window"
PROP_RENDERER_CREATE_SURFACE_POINTER :: "SDL.clay_renderer.create.surface"
PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER :: "SDL.clay_renderer.create.output_colorspace"
PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER :: "SDL.clay_renderer.create.present_vsync"
PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER :: "SDL.clay_renderer.create.vulkan.instance"
PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER :: "SDL.clay_renderer.create.vulkan.surface"
PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER :: "SDL.clay_renderer.create.vulkan.physical_device"
PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER :: "SDL.clay_renderer.create.vulkan.device"
PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.clay_renderer.create.vulkan.graphics_queue_family_index"
PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.clay_renderer.create.vulkan.present_queue_family_index"

PropertiesID :: distinct u32

@(default_calling_convention = "c", link_prefix = "SDL_")
foreign lib {
	CreateProperties :: proc() -> PropertiesID ---
	DestroyProperties :: proc(props: PropertiesID) ---
	SetBooleanProperty :: proc(id: PropertiesID, name: cstring, value: bool) -> bool ---
	SetFloatProperty :: proc(id: PropertiesID, name: cstring, value: f32) -> bool ---
	SetNumberProperty :: proc(id: PropertiesID, name: cstring, value: i64) -> bool ---
	SetPointerProperty :: proc(id: PropertiesID, name: cstring, value: rawptr) -> bool ---
	SetStringProperty :: proc(id: PropertiesID, name: cstring, value: cstring) -> bool ---
}
