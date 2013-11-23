return {
	-- Backgrounds
	scenes = {
		logo = "runtimedata/graphics/logo.png",
	},

	-- Sprites
	spritesheet = {
		texture = "runtimedata/graphics/sprites/",
		data = "runtimedata.graphics.sprites."
	},

	game = {
		background = "runtimedata/graphics/game/background.jpg"
	},

	-- Masks
	masks = {
		cut45 = graphics.newMask("runtimedata/graphics/masks/cut-45.png"),
		cut90 = graphics.newMask("runtimedata/graphics/masks/cut-90.png"),
		cut180 = graphics.newMask("runtimedata/graphics/masks/cut-180.png")
	}
}
