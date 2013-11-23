-----------------------------------------------------------------------------------------
--
-- Text.lua
--
-- An abstract layer over the Corona text fields, used to simplify how it is handled by
-- Corona.
-- It features:
--  A cleaner way to handle the text objects
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")
local EcussonDisplayObject = require("lib.ecusson.internal.EcussonDisplayObject")

-----------------------------------------------------------------------------------------

local Super = EcussonDisplayObject
local Class = utils.extend(Super)

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the text field
--
-- Parameters:
--  group: The display group to add the text to (optional)
--  text: The text to display
--  referencePoint: The reference point (default is display.TopLeftReferencePoint)
--  width: The text width for multiline purpose (default is 0, i.e. not used)
--  height: The text height for multiline purpose (default is 0, i.e. not used)
--  position: The position (default is vec2(0, 0))
--  rotation: The text rotation (default is 0)
--  font: The font (default is native.systemFont)
--  size: The font size (default is 8)
--  color: The color, as color components (r, g, b, a (optional)) (default is 0, 0, 0, 255)
--  opacity: The opacity value, in [0 ; 1] (default is 1)
--  numeric: If true, then displays the text as a formatted numeric value
--  visible: If false, the object will not appear on screen (default is true)
--  shadows: Text shadows to apply behind the text (optional), as an array of:
--   offset: The shadow offset, as a vec2
--   color: The shadow color, as color components (r, g, b, a (optional)) (default is 0, 0, 0, 255)
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.width = options.width or 0
	self.height = options.height or 0
	self.font = options.font or native.systemFont
	self.size = options.size or 8
	self.color = options.color or { 0, 0, 0, 255 }
	self.color[4] = self.color[4] or 255
	self.numeric = options.numeric
	self.shadows = {}

	-- Apply numeric formatting
	if self.numeric and options.text then
		options.text = self:formatNumber(options.text)
	end

	-- Create group
	if options.shadows then
		self.group = display.newGroup()

		-- Insert group
		if options.group then
			options.group:insert(self.group)
		end
	end

	-- Create shadows
	if options.shadows then
		for _, shadow in pairs(options.shadows) do
			self.shadows[#self.shadows + 1] = Text.create{
				group = self.group,
				text = options.text,
				referencePoint = options.referencePoint,
				width = options.width,
				height = options.height,
				position = shadow.offset,
				rotation = options.rotation,
				font = options.font,
				size = options.size,
				color = shadow.color
			}
		end
	end

	-- Create Corona text
	if self.width > 0 then
		self._displayObject = display.newText(options.text or "", 0, 0, self.width, self.height, self.font, self.size)
	else
		self._displayObject = display.newText(options.text or "", 0, 0, self.font, self.size)
	end

	self:setColor(self.color)

	-- Prevent Ecusson display object to add the text to the parent group
	Super.super(self, options)

	-- Insert text into group and position it
	if self.group then
		self._displayObject.x = 0
		self._displayObject.y = 0
	end

	return self
end

-- Destroy the text
function Class:destroy()
	for _, shadow in pairs(self.shadows) do
		shadow:destroy()
	end

	self._displayObject:removeSelf()

	if self.group then
		self.group:removeSelf()
	end

	Super.destroy(self)

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:formatNumber(number)
	if number == "" then
		return ""
	else
		local left, num, right = string.match(number, '^([^%d]*%d)(%d*)(.-)$')
		return left..(num:reverse():gsub('(%d%d%d)', '%1 '):reverse())..right
	end
end

-- Move the display object to a given position
--
-- Parameters:
--  position: The position
function Class:setPosition(position)
	self.position = position

	local target = self:getDisplayGroup()
	target.x = position.x
	target.y = position.y
end

-- Set the text color
--
-- Parameters:
--  color: The four components of a color, in this order: R, G, B, Alpha
function Class:setColor(color)
	color[4] = color[4] or 255
	self._displayObject:setTextColor(color[1], color[2], color[3], color[4])
end

-- Set the text content
--
-- Parameters:
--  text: The new text content
function Class:setText(text)
	if self.numeric then
		text = self:formatNumber(text)
	end

	self._displayObject.text = text
	self:getDisplayGroup():setReferencePoint(self.referencePoint)
	self:setPosition(self.position)

	for _, shadow in pairs(self.shadows) do
		shadow:setText(text)
	end
end

-- Set the text size
--
-- Parameters:
--  size: The new text size
function Class:setSize(size)
	self.size = size
	self._displayObject.size = size

	for _, shadow in pairs(self.shadows) do
		shadow:setSize(size)
	end
end

-----------------------------------------------------------------------------------------

return Class
