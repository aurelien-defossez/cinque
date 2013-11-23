return {
	framerate = {
		target = 30,
		timeWindow = 0.5,
		growth = 0.15
	},

	screen = {
		width = display.contentWidth,
		halfWidth = display.contentWidth * .5,
		height = display.contentHeight,
		halfHeight = display.contentHeight * .5
	},

	loading = {
		fadeIn = 1,
		idle = 1,
		fadeOut = 1
	},

	logo = {
		offset = vec2(0, -12),
		backgroundColor = { 255, 255, 255 },
		width = 256,
		height = 60
	},

	borders = {
		width = 105,
		color = { 0, 0, 0 }
	}
}
