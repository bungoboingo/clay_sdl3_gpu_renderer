package sdl3_ttf

import sdl "../sdl3"
import "core:c"

foreign import lib "system:SDL3_ttf"

Font :: struct {}

Text :: struct {
	text:      cstring,
	num_lines: c.int,
	refcount:  c.int,
	internal:  rawptr,
}

TextEngine :: struct {}

Direction :: enum c.int {
	LTR = 0,
	RTL,
	TTB,
	BTT,
}

// Normal == empty
FontStyleFlag :: enum u32 {
	BOLD          = 0,
	ITALIC        = 1,
	UNDERLINE     = 2,
	STRIKETHROUGH = 3,
}

FontStyleFlags :: bit_set[FontStyleFlag; u32]
FONT_STYLE_NORMAL :: FontStyleFlags {}
FONT_STYLE_BOLD :: FontStyleFlags { .BOLD }
FONT_STYLE_ITALIC :: FontStyleFlags { .ITALIC }
FONT_STYLE_UNDERLINE :: FontStyleFlags { .UNDERLINE }
FONT_STYLE_STRIKETHROUGH :: FontStyleFlags { .STRIKETHROUGH }

HintingFlags :: enum c.int {
	NORMAL = 0,
	LIGHT,
	MONO,
	NONE,
	LIGHT_SUBPIXEL,
}

TTF_PROP_FONT_OUTLINE_LINE_CAP_NUMBER :: "SDL_ttf.font.outline.line_cap"
TTF_PROP_FONT_OUTLINE_LINE_JOIN_NUMBER :: "SDL_ttf.font.outline.line_join"
TTF_PROP_FONT_OUTLINE_MITER_LIMIT_NUMBER :: "SDL_ttf.font.outline.miter_limit"

HorizontalAlignment :: enum c.int {
	INVALID = -1,
	LEFT,
	CENTER,
	RIGHT,
}

GPUAtlasDrawSequence :: struct {
	atlas_texture: ^sdl.GPUTexture,
	vertex_positions: [^]sdl.FPoint,
	uvs: [^]sdl.FPoint, // Normalized
	num_verticies: c.int,
	indices: [^]c.int,
	num_indices: c.int,
	next: ^GPUAtlasDrawSequence, // If nil, this is the last text in the sequence
}

GPUTextEngineWinding :: enum c.int {
	INVALID = -1,
	CLOCKWISE,
	COUNTERCLOCKWISE,
}

SubStringFlag :: enum u32 {
	TEXT_START,
	LINE_START,
	LINE_END,
	TEXT_END,
}

SubString :: struct {
	flags: SubStringFlag,
	offset: c.int,
	length: c.int,
	line_index: c.int,
	cluster_index: c.int,
	rect: sdl.Rect,
}

/// General
@(default_calling_convention = "c", link_prefix = "TTF_")
foreign lib {
	Init :: proc() -> bool ---
	CreateGPUTextEngine :: proc(device: ^sdl.GPUDevice) -> ^TextEngine ---
	DestroyGPUTextEngine :: proc(engine: ^TextEngine) ---
	Quit :: proc() ---
}

/// Fonts
@(default_calling_convention = "c", link_prefix = "TTF_")
foreign lib {
	CloseFont :: proc(font: ^Font) ---
	FontHasGlyph :: proc(font: ^Font, glyph: u32) -> bool ---
	FontIsFixedWidth :: proc(font: ^Font) -> bool ---
	GetFontAscent :: proc(font: ^Font) -> c.int ---
	GetFontDescent :: proc(font: ^Font) -> c.int ---
	GetFontDirection :: proc(font: ^Font) -> Direction ---
	GetFontDPI :: proc(font: ^Font, hdpi: ^c.int, vdpi: ^c.int) -> bool ---
	GetFontFamilyName :: proc(font: ^Font) -> cstring ---
	GetFontGeneration :: proc(font: ^Font) -> u32 ---
	GetFontHeight :: proc(font: ^Font) -> c.int ---
	GetFontHinting :: proc(font: ^Font) -> HintingFlags ---
	GetFontKerning :: proc(font: ^Font) -> bool ---
	/// Returns the font's recommended spacing
	GetFontLineSkip :: proc(font: ^Font) -> c.int ---
	GetFontOutline :: proc(font: ^Font) -> c.int ---
	GetFontProperties :: proc(font: ^Font) -> sdl.PropertiesID ---
	GetFontSize :: proc(font: ^Font) -> f32 ---
	GetFontStyle :: proc(font: ^Font) -> FontStyleFlags ---
	GetFontStyleName :: proc(font: ^Font) -> cstring ---
	GetFontWrapAlignment :: proc(font: ^Font) -> HorizontalAlignment ---
	GetFreeTypeVersion :: proc(major: ^c.int, minor: ^c.int, patch: ^c.int) ---
	GetGlyphMetrics :: proc(font: ^Font, glyph: u32, min_x: ^c.int, max_x: ^c.int, min_y: ^c.int, max_y: ^c.int, advance: ^c.int) -> bool ---
	GetGlyphScript :: proc(glyph: u32, script: ^c.char, script_size: c.size_t) -> bool ---
	/// `stream`: A `sdl.IOStream` to provide a font's file data
	/// `close_io`: Close src when the font is closed, false to leave it open
	/// `point_size`: Font point size to use for the newly-opened font
	OpenFontIO :: proc(stream: ^sdl.IOStream, close_io: bool, point_size: f32) -> ^Font ---
	OpenFont :: proc(file: cstring, point_size: f32) -> ^Font ---
	SetFontDirection :: proc(font: ^Font, direction: Direction) -> bool ---
	SetFontHinting :: proc(font: ^Font, hinting_flags: HintingFlags) ---
	SetFontKerning :: proc(font: ^Font, enabled: bool) ---
	SetFontLineSkip :: proc(font: ^Font, lineskip: c.int) ---
	SetFontOutline :: proc(font: ^Font, outline: c.int)  -> bool ---
	SetFontScript :: proc(font: ^Font, script: cstring) -> bool ---
	SetFontSize :: proc(font: ^Font, pt_size: f32) -> bool ---
	SetFontSizeDPI :: proc(font: ^Font, pt_size: f32, hdpi: c.int, vdpi: c.int) -> bool ---
	SetFontStyle :: proc(font: ^Font, style: FontStyleFlags) ---
	SetFontWrapAlignment :: proc(font: ^Font, horizontal_alignment: HorizontalAlignment) ---
	SetGPUTextEngineWinding :: proc(engine: ^TextEngine, winding: GPUTextEngineWinding) ---
}

/// Text
@(default_calling_convention = "c", link_prefix = "TTF_")
foreign lib {
	AppendTextString :: proc(text: ^Text, str: cstring, length: c.size_t) -> bool ---
	CreateText :: proc(engine: ^TextEngine, font: ^Font, text: cstring, length: c.size_t) -> ^Text ---
	DeleteTextString :: proc(text: ^Text, offset: c.int, length: c.int) -> bool ---
	DestroyText :: proc(text: ^Text) ---
	GetGPUTextDrawData :: proc(text: ^Text) -> ^GPUAtlasDrawSequence ---
	GetGPUTextEngineWinding :: proc(engine: ^TextEngine) -> GPUTextEngineWinding ---
	GetNextTextSubString :: proc(text: ^Text, substring: ^SubString, next: ^SubString) -> bool ---
	GetPreviousTextSubString :: proc(text: ^Text, substring: ^SubString, previous: ^SubString) -> bool ---
	/// Calculate the dimensions of a rendered string of UTF-8 text.
	GetStringSize :: proc(font: ^Font, text: cstring, length: c.size_t, w: ^c.int, h: ^c.int) -> bool ---
	GetStringSizeWrapped :: proc(font: ^Font, text: cstring, length: c.size_t, wrap_width: c.int, w: ^c.int, h: ^c.int) -> bool ---
	GetTextColor :: proc(text: ^Text, r: ^u8, g: ^u8, b: ^u8, a: ^u8) -> bool ---
	GetTextColorFloat :: proc(text: ^Text, r: ^f32, g: ^f32, b: ^f32, a: ^f32) -> bool ---
	GetTextEngine :: proc(text: ^Text) -> ^TextEngine ---
	GetTextFont :: proc(text: ^Text) -> ^Font ---
	GetTextPosition :: proc(text: ^Text, x: ^c.int, y: ^c.int) -> bool ---
	GetTextProperties :: proc(text: ^Text) -> sdl.PropertiesID ---
	GetTextSize :: proc(text: ^Text, width: ^c.int, height: ^c.int) -> bool ---
	GetTextSubString :: proc(text: ^Text, offset: c.int, substring: ^SubString) -> bool ---
	GetTextSubStringForLine :: proc(text: ^Text, line: c.int, substring: ^SubString) -> bool ---
	GetTextSubStringForPoint :: proc(text: ^Text, x: c.int, y: c.int, substring: ^SubString) -> bool ---
	GetTextSubStringsForRange :: proc(text: ^Text, offset: c.int, length: c.int, count: ^c.int) -> [^]^SubString ---
	GetTextWrapping :: proc(text: ^Text, wrap_length: ^c.int) -> bool ---
	GetTextWrapWidth :: proc(text: ^Text, wrap_width: ^c.int) -> bool ---
	InsertTextString :: proc(text: ^Text, offset: c.int, str: cstring, length: c.size_t) -> bool ---
	// Calculate how much of a UTF-8 string will fit in a given width.
	MeasureString :: proc(font: ^Font, text: cstring, length: c.size_t, max_width: c.int, measured_width: ^c.int, measured_length: ^c.size_t) -> bool ---
	SetTextColor :: proc(text: ^Text, r: u8, g: u8, b: u8, a: u8) -> bool ---
	SetTextColorFloat :: proc(text: ^Text, r: f32, g: f32, b: f32, a: f32) -> bool ---
	SetTextEngine :: proc(text: ^Text, engine: ^TextEngine) -> bool ---
	SetTextFont :: proc(text: ^Text, font: ^Font) -> bool ---
	SetTextPosition :: proc(text: ^Text, x: c.int, y: c.int) -> bool ---
	SetTextString :: proc(text: ^Text, str: cstring, length: c.size_t) -> bool ---
	SetTextWrapping :: proc(text: ^Text, wrap_length: c.int) -> bool ---
	SetTextWrapWhitespaceVisible :: proc(text: ^Text, visible: bool) -> bool ---
	SetTextWrapWidth :: proc(text: ^Text, wrap_width: c.int) -> bool ---
}
