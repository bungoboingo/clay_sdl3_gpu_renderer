package gui

import "base:runtime"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import clay "library:clay-odin"
import sdl "library:sdl3"
import "renderer"

WINDOW_WIDTH :: 1024
WINDOW_HEIGHT :: 728
WINDOW_FLAGS :: sdl.WindowFlags{.RESIZABLE, .HIGH_PIXEL_DENSITY}

device: ^sdl.GPUDevice
window: ^sdl.Window
debug_enabled := false

main :: proc() {
	defer destroy()

	when ODIN_DEBUG == true {
		context.logger = log.create_console_logger(lowest = .Debug)

		//----- Tracking allocator ----------------------------------
		// Temp
		track_temp: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track_temp, context.temp_allocator)
		context.temp_allocator = mem.tracking_allocator(&track_temp)
		// Default
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)
		// Log a warning about any memory that was not freed by the end of the program.
		// This could be fine for some global state or it could be a memory leak.
		defer {
			// Temp allocator
			if len(track_temp.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed - temp allocator: ===\n",
					len(track_temp.allocation_map),
				)
				for _, entry in track_temp.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track_temp.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees - temp allocator: ===\n",
					len(track_temp.bad_free_array),
				)
				for entry in track_temp.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track_temp)
			// Default allocator
			if len(track.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed - main allocator: ===\n",
					len(track.allocation_map),
				)
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees - main allocator: ===\n",
					len(track.bad_free_array),
				)
				for entry in track.bad_free_array {
					fmt.eprintf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	renderer.odin_context = context

	if !sdl.Init(.VIDEO) {
		log.error("Failed to initialize SDL:", sdl.GetError())
	}

	window = sdl.CreateWindow("Clay Renderer Test", WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_FLAGS)
	if window == nil {
		log.error("Failed to create window:", sdl.GetError())
		os.exit(1)
	}

	device = sdl.CreateGPUDevice(renderer.SHADER_TYPE, true, nil)
	if device == nil {
		log.error("Failed to create GPU device:", sdl.GetError())
		os.exit(1)
	}
	driver := sdl.GetGPUDeviceDriver(device)
	log.info("Created GPU device:", driver)

	if !sdl.ClaimWindowForGPUDevice(device, window) {
		log.error("Failed to claim GPU device for window:", sdl.GetError())
	}

	renderer.init(device, window, WINDOW_WIDTH, WINDOW_HEIGHT)

	last_frame_time := sdl.GetTicks()

	program: for {
		defer free_all(context.temp_allocator)

		frame_time := sdl.GetTicks()

		cmd_buffer := sdl.AcquireGPUCommandBuffer(device)
		if cmd_buffer == nil {
			log.error("Failed to acquire command buffer")
			os.exit(1)
		}

		if update(cmd_buffer, frame_time - last_frame_time) {
			log.debug("User command to quit")
			break program
		}

		draw(cmd_buffer)

		last_frame_time = frame_time
	}
}

destroy :: proc() {
	renderer.destroy(device)
	sdl.ReleaseWindowFromGPUDevice(device, window)
	sdl.DestroyWindow(window)
	sdl.DestroyGPUDevice(device)
}

update :: proc(cmd_buffer: ^sdl.GPUCommandBuffer, delta_time: u64) -> bool {
	frame_time := f32(delta_time) / 1000.0
	input := input()

	render_cmds: clay.ClayArray(clay.RenderCommand) = layout()
	renderer.prepare(device, window, cmd_buffer, &render_cmds, input.mouse_delta, frame_time)

	return input.should_quit
}

Input :: struct {
	mouse_delta: [2]f32,
	should_quit: bool,
}

input :: proc() -> Input {
	result := Input{}

	event: sdl.Event
	for sdl.PollEvent(&event) == true {
		#partial switch event.type {
		case .KEY_DOWN:
			#partial switch event.key.key {
			case .ESCAPE:
				result.should_quit = true
			case .D:
				if .LSHIFT in event.key.mod {
					debug_enabled = !debug_enabled
					clay.SetDebugModeEnabled(debug_enabled)
				}
			}
		case .QUIT:
			result.should_quit = true
		case .MOUSE_WHEEL:
			result.mouse_delta[0] = event.wheel.x
			result.mouse_delta[1] = event.wheel.y
		case .FINGER_MOTION:
		//TODO update scroll & "mouse pos" from touch
		}
	}

	return result
}

draw :: proc(cmd_buffer: ^sdl.GPUCommandBuffer) {
	renderer.draw(device, window, cmd_buffer)
	sdl.SubmitGPUCommandBuffer(cmd_buffer)
}
