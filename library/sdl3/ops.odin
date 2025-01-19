package sdl3

import "core:c"

foreign import lib "system:SDL3"

GPULoadOp :: enum c.int {
	// The previous contents of the texture will be preserved
	LOAD,
	// The contents of the texture will be cleared to a color
	CLEAR,
	// The previous contents of the texture need not be preserved. The contents will be undefined
	DONT_CARE,
}

GPUStoreOp :: enum c.int {
	// The contents generated during the render pass will be written to memory.
	STORE,
	// The contents generated during the render pass are not needed and may be discarded. The contents will be undefined.
	DONT_CARE,
	// The multisample contents generated during the render pass will be resolved to a non-multisample texture.
	// The contents in the multisample texture may then be discarded and will be undefined.
	RESOLVE,
	// The multisample contents generated during the render pass will be resolved to a non-multisample texture.
	// The contents in the multisample texture will be written to memory.
	RESOLVE_AND_STORE,
}

GPUCompareOp :: enum c.int {
	INVALID,
	NEVER,
	LESS,
	EQUAL,
	LESS_OR_EQUAL,
	GREATER,
	NOT_EQUAL,
	GREATER_OR_EQUAL,
	ALWAYS,
}

GPUStencilOp :: enum c.int {
	INVALID,
	KEEP,
	ZERO,
	REPLACE,
	INCREMENT_AND_CLAMP,
	DECREMENT_AND_CLAMP,
	INVERT,
	INCREMENT_AND_WRAP,
	DECREMENT_AND_WRAP,
}

GPUBlendOp :: enum c.int {
	INVALID,
	ADD,
	SUBTRACT,
	REVERSE_SUBTRACT,
	MIN,
	MAX,
}

GPUStencilOpState :: struct {
	fail_op:       GPUStencilOp,
	pass_op:       GPUStencilOp,
	depth_fail_op: GPUStencilOp,
	compare_op:    GPUCompareOp,
}
