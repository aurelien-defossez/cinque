-----------------------------------------------------------------------------------------
--
-- MenuButton.lua
--
-- A menu button than can be clicked.
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

-- Set the class default values
--
-- Parameters:
--  width: The width
--  height: The height
--  selected: Tells whether the button is selected by default
--  strokeWidth: the stroke width
--  cornerRadius: The corner radius
--  fontSize: The font size
--  color: The background fill color
--  strokeColor: The stroke color
--  textColor: The text color
--  selectedColor: The background fill color when selected
--  selectedStrokeColor: The stroke color when selected
--  selectedTextColor: The text color when selected
function Class.setDefaults(options)
	defaults = {
		width = options.width or 60,
		height = options.height or 15,
		selected = options.selected or false,
		strokeWidth = options.strokeWidth or 1,
		cornerRadius = options.cornerRadius or 3,
		fontSize = options.fontSize or 6,
		color = options.color or { 180, 180, 180 },
		strokeColor = options.strokeColor or { 42, 42, 42 },
		textColor = options.textColor or { 0, 0, 0 },
		selectedColor = options.selectedColor or { 255, 255, 255 },
		selectedStrokeColor = options.selectedStrokeColor or { 0, 0, 0 },
		selectedTextColor = options.selectedTextColor or { 0, 0, 0 },
	}
end

-- Initialize defaults
Class.setDefaults{};

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create a button
--
-- Parameters:
--  text: The text to display
--  actionPerformed: The action performed when the button is touched
--  selected: Tells whether the button is selected
--  width: The width
--  height: The height
--  strokeWidth: the stroke width
--  cornerRadius: The corner radius
--  fontSize: The font size
--  color: The background fill color
--  strokeColor: The stroke color
--  textColor: The text color
--  selectedColor: The background fill color when selected
--  selectedStrokeColor: The stroke color when selected
--  selectedTextColor: The text color when selected
function Class.create(options)
	local self = utils.extend(Class)

	local x = options.x or 0
	local y = options.y or 0

	-- Create group
	self.group = display.newGroup()

	-- Position group
	self.group.x = x
	self.group.y = y
	
	-- Initialize attributes
	self.width = options.width or defaults.width
	self.height = options.height or defaults.height
	self.selected = options.selected or defaults.selected
	self.color = options.color or defaults.color
	self.strokeColor = options.strokeColor or defaults.strokeColor
	self.textColor = options.textColor or defaults.textColor
	self.selectedColor = options.selectedColor or defaults.selectedColor
	self.selectedStrokeColor = options.selectedStrokeColor or defaults.selectedStrokeColor
	self.selectedTextColor = options.selectedTextColor or defaults.selectedTextColor
	self.actionPerformed = options.actionPerformed

	-- Draw background
	self.background = Rectangle.create{
		group = self.group,
		width = self.width,
		height = self.height,
		referencePoint = display.TopLeftReferencePoint,
		strokeWidth = options.strokeWidth or defaults.strokeWidth,
		cornerRadius = options.cornerRadius or defaults.cornerRadius
	}

	-- Text
	self.buttonText = Text.create{
		group = self.group,
		text = options.text,
		referencePoint = display.CenterReferencePoint,
		position = vec2(self.width * 0.5, self.height * 0.5),
		size = options.fontSize or defaults.fontSize
	}

	-- Set color depending on state
	self:setSelected(self.selected)

	-- Bind events
	self.background:addEventListener("touch", self)
	
	return self
end

-- Destroy the button
function Class:destroy()
	self.buttonText:destroy()
	self.background:removeEventListener("touch", self)
	self.background:destroy()
	self.group:removeSelf()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Get the display object
--
-- Returns:
--  The Corona display object shadowed by Ecusson
function Class:getDisplayObject()
	return self.group
end

-- Show the button
function Class:show()
	self.group.isVisible = true
end

-- Hide the button
function Class:hide()
	self.group.isVisible = false
end

-- Move the button
--
-- Parameters:
--  x: The X position
--  y: The Y position
function Class:moveTo(options)
	self.group.x = options.x
	self.group.y = options.y
end

-- Sets the button state, thus changing its appearance
--
-- Parameters:
--  selected: True if the button is selected
function Class:setSelected(selected)
	self.selected = selected

	if self.selected then
		self.background:setColor(self.selectedColor)
		self.background:setStrokeColor(self.selectedStrokeColor)
		self.buttonText:setColor(self.selectedTextColor)
	else
		self.background:setColor(self.color)
		self.background:setStrokeColor(self.strokeColor)
		self.buttonText:setColor(self.textColor)
	end
end

-----------------------------------------------------------------------------------------
-- Callbacks
-----------------------------------------------------------------------------------------

-- Tap handler on the button
--
-- Parameters:
--  event: The event thrown
function Class:touch(event)
	if event.phase == "ended" then
		self.actionPerformed(self)
	end

	return true
end

-----------------------------------------------------------------------------------------

return Class
