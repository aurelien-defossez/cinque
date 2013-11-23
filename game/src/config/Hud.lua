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
	},

	buttons = {
		width = 125,
		height = 24,
		strokeWidth = 1,
		cornerRadius = 3,
		fontSize = 10,
		color = { 255, 190, 240 },
		selectedColor = { 200, 50, 180 },
		strokeColor = { 200, 50, 180 },
		selectedStrokeColor = { 255, 180, 40 },
		textColor = { 40, 40, 40 },
		selectedTextColor = { 255, 255, 255 }
	},
	
	windows = {
		xpadding = 5,
		ypadding = 5,
		strokeWidth = 2,
		cornerRadius = 5,
		titleHeight = 8,
		fontSize = 12,
		color = { 240, 90, 230 },
		strokeColor = { 200, 50, 180 },
		textColor = { 40, 40, 40 }
	}
}
