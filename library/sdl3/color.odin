package sdl3

foreign import lib "system:SDL3"

Color :: struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
}

FColor :: struct {
	r: f32,
	g: f32,
	b: f32,
	a: f32,
}

FPoint :: struct {
	x: f32,
	y: f32,
}