-----------------------------------------------------------------------------------------
--
-- MenuWindow.lua
--
-- A menu with some buttons in it.
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")
local vec2 = require("lib.ecusson.math.vec2")
local Rectangle = require("lib.ecusson.Rectangle")
local Text = require("lib.ecusson.Text")

-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local defaults = {}

-----------------------------------------------------------------------------------------
-- Class Initialization
-----------------------------------------------------------------------------------------

-- Initialize the screen dimensions
--
-- Parameters:
--  width: The screen width,
--  height: The screen height
function Class.initializeDimensions(options)
	screenWidth  = options.width
	screenHeight = options.height
end

-- Set the class default values
--
-- Parameters:
--   xpadding: The padding left and right of the buttons
--   ypadding: The padding on top and bottom of the window
--   strokeWidth: The stroke width
--   fontSize: The font size
--   cornerRadius: The corner radius
--   titleHeight: The height of the title section
--   color: The background fill color
--   strokeColor: The stroke color
--   textColor: The text color
--   displayBackground: Tells whether the background should be displayed by default
function Class.setDefaults(options)
	defaults = {
		xpadding = options.xpadding or 5,
		ypadding = options.ypadding or 5,
		strokeWidth = options.strokeWidth or 1,
		fontSize = options.fontSize or 10,
		cornerRadius = options.cornerRadius or 3,
		titleHeight = options.titleHeight or 8,
		color = options.color or { 128, 128, 128 },
		strokeColor = options.strokeColor or { 0, 0, 0 },
		textColor = options.textColor or { 0, 0, 0 },
		displayBackground = options.displayBackground ~= nil and options.displayBackground or false
	}
end

-- Initialize defaults
Class.setDefaults{};

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create a window menu
--
-- Parameters:
--  group: The display group
--  buttons: The list of buttons to display
--  title: The window title, empty meaning no title (default is no title)
--  displayBackground: True if the background has to be shown (default is false)
--  columns: The number of columns (default is 1)
--  x: The X position
--  y: The Y position
function Class.create(options)
	local self = utils.extend(Class)

	-- Create group
	self.group = display.newGroup()

	if options.group then
		options.group:insert(self.group)
	end

	-- Initialize attributes
	local buttonHeight = 0
	local buttonPadding = 10
	local columns = options.columns or 1
	local xpadding = options.xpadding or defaults.xpadding
	local ypadding = options.ypadding or defaults.ypadding
	local titleHeight = options.titleHeight or defaults.titleHeight

	if #options.buttons > 0 then
		local firstButton = options.buttons[1]

		buttonWidth = firstButton.width
		buttonHeight = firstButton.height
		buttonPadding = buttonHeight * .25
	end

	self.buttons = options.buttons
	self.onClose = options.onClose
	
	local width = xpadding + columns * (xpadding + buttonWidth)
	local height = 2 * ypadding + math.ceil(#self.buttons / columns) * (buttonPadding + buttonHeight)

	if options.title then
		height = height + titleHeight
	end

	-- Draw background
	if options.displayBackground ~= nil and options.displayBackground or defaults.displayBackground then
		self.background = Rectangle.create{
			group = self.group,
			referencePoint = display.TopLeftReferencePoint,
			width = width,
			height = height,
			cornerRadius = options.cornerRadius or defaults.cornerRadius,
			strokeWidth = options.strokeWidth or defaults.strokeWidth,
			color = options.color or defaults.color,
			strokeColor = options.strokeColor or strokeColor
		}
	end
	
	-- Title
	if options.title then
		self.windowTitle = Text.create{
			group = self.group,
			text = options.title,
			referencePoint = display.CenterReferencePoint,
			position = vec2(width * 0.5, ypadding + titleHeight * .5),
			size = options.fontSize or defaults.fontSize,
			color = options.textColor or defaults.textColor
		}
	end

	-- Position buttons
	local offset = ypadding + buttonPadding
	if options.title then
		offset = offset + titleHeight
	end

	local currentColumn = 1
	for _, button in pairs(self.buttons) do
		self.group:insert(button:getDisplayObject())
		button:getDisplayObject().x = xpadding + (currentColumn - 1) * (buttonWidth + xpadding)
		button:getDisplayObject().y = offset

		currentColumn = currentColumn + 1
		if currentColumn > columns then
			currentColumn = 1
			offset = offset + buttonHeight + buttonPadding
		end
	end

	-- Position group
	self.group.x = options.x or (screenWidth - width) * .5
	self.group.y = options.y or (screenHeight - height) * .5

	return self
end

-- Destroy the panel
function Class:destroy()
	-- Destroy buttons
	for _, button in pairs(self.buttons) do
		button:destroy()
	end

	if self.windowTitle then
		self.windowTitle:destroy()
	end

	if self.background then
		self.background:destroy()
	end

	-- Remove display group
	self.group:removeSelf()

	-- Send close callback
	if self.onClose then
		self.onClose()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Show the window
function Class:show()
	self.group.isVisible = true

	-- Add button listeners
	for _, button in pairs(self.buttons) do
		button:show()
	end
end

-- Hide the window
function Class:hide()
	-- Remove button listeners
	for _, button in pairs(self.buttons) do
		button:hide()
	end

	self.group.isVisible = false
end

-----------------------------------------------------------------------------------------

return Class
