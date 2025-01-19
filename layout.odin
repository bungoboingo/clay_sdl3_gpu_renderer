package gui
import clay "library:clay-odin"
import renderer "renderer"

body_text_config := clay.TextElementConfig {
	fontId    = renderer.JETBRAINS_MONO_REGULAR,
	fontSize  = 24,
	textColor = clay.Color{255, 255, 255, 255},
}

body_text_config_2 := clay.TextElementConfig {
	fontId    = renderer.JETBRAINS_MONO_REGULAR,
	fontSize  = 16,
	textColor = clay.Color{255, 255, 255, 255},
}

layout :: proc() -> clay.ClayArray(clay.RenderCommand) {
	clay.BeginLayout()

	if clay.UI(
		clay.ID("OuterContainer"),
		clay.Layout(
			{
				layoutDirection = .TOP_TO_BOTTOM,
				sizing = {clay.SizingGrow({}), clay.SizingGrow({})},
				childAlignment = {x = .CENTER, y = .CENTER},
				childGap = 16,
			},
		),
		clay.Rectangle({color = clay.Color{40, 40, 40, 255}}),
	) {
		if clay.UI(
			clay.ID("Box1"),
			clay.Layout({sizing = {clay.SizingFixed(200), clay.SizingFixed(200)}}),
			clay.Rectangle(
				{
					color = clay.Color{80, 80, 120, 255},
					cornerRadius = clay.CornerRadius{40.0, 40.0, 40.0, 40.0},
				},
			),
			border(
				10,
				clay.Color{255.0, 255.0, 255.0, 255.0},
				clay.Color{255, 255, 255, 255},
				40.0,
			),
		) {}

		if clay.UI(
			clay.ID("Box2"),
			clay.Layout({sizing = {clay.SizingFixed(200), clay.SizingFixed(200)}}),
			clay.Rectangle(
				{
					color = clay.Color{100, 100, 40, 255},
					cornerRadius = clay.CornerRadius{40.0, 40.0, 40.0, 40.0},
				},
			),
			border(10, clay.Color{255.0, 255.0, 255.0, 255.0}, clay.Color{0, 0, 0, 255}, 40.0),
		) {}

		clay.Text("Larger Text", &body_text_config)
		clay.Text("Smaller Text", &body_text_config_2)
	}

	return clay.EndLayout()
}

// We store the blend color in the right color slot to pass into the fragment shader
border :: proc(
	width: u32,
	border_color: clay.Color,
	underlying_color: clay.Color,
	radius: f32,
) -> clay.TypedConfig {
	return clay.Border(
		clay.BorderElementConfig {
			right = clay.BorderData {
				width,
				clay.Color{underlying_color.r, underlying_color.g, underlying_color.b, 0.0},
			},
			top = clay.BorderData{width, border_color},
			cornerRadius = clay.CornerRadius{radius, radius, radius, radius},
		},
	)
}
