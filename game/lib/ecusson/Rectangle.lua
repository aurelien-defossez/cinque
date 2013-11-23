-----------------------------------------------------------------------------------------
--
-- Rectangle.lua
--
-- An abstract layer over the Corona rectangles, used to simplify how it is handled by
-- Corona.
-- It features:
--  The resizing of the rectangle, even if the reference point is not the Center one
--  The non-visibility of mathematically false rectangles (width or height <= 0)
--  Rounded rectangles
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

-- Create the rectangle
--
-- Parameters:
--  group: The display group to add the rectangle to (optional)
--  referencePoint: The reference point (default is display.TopLeftReferencePoint)
--  width: The rectangle width (default is 0)
--  height: The rectangle height (default is 0)
--  position: The position (default is vec2(0, 0))
--  rotation: The rectangle rotation (default is 0)
--  color: The color, as an array of color components (r, g, b, a (optional)) (default is 255, 255, 255, 255)
--  gradient: The gradient parameters: (note: does not work with cornerRadius and overrides color parameter)
--   from: The starting color
--   to: The ending color
--   direction: The direction ("down", "up", "left" or "right")
--  strokeColor: The stroke color, as an array of color components (r, g, b, a (optional)) (default is 0, 0, 0, 255)
--  strokeWidth: The stroke width (default is 0)
--  cornerRadius: The corner radius (default is 0)
--  image: The image to display (default is nil)
--  opacity: The opacity value, in [0 ; 1] (default is 1)
--  visible: If false, the object will not appear on screen (default is true)
--  toBack: If true, creates the object on back of the group
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.width = options.width or 0
	self.height = options.height or 0
	self.strokeWidth = options.strokeWidth or 0
	self.cornerRadius = options.cornerRadius or 0

	-- Create Corona rectangle
	if options.image then
		self._displayObject = display.newImageRect(options.image, self.width, self.height)

		if not self._displayObject then
			error("Cannot instantiate rectangle, image not found: "..options.image)
		end
	elseif self.cornerRadius > 0 then
		self._displayObject = display.newRoundedRect(0, 0, self.width, self.height, self.cornerRadius)
	else
		self._displayObject = display.newRect(0, 0, self.width, self.height)
	end

	Super.super(self, options)

	-- Initialize rectangle attributes
	self._displayObject.strokeWidth = self.strokeWidth
	self:setStrokeColor(options.strokeColor or { 0, 0, 0, 255 })

	if options.gradient then
		self:setGradient(options.gradient)
	end

	-- Set visible
	self:checkVisibility()

	return self
end

-- Destroy the rectangle
function Class:destroy()
	Super.destroy(self, options)

	self._displayObject:removeSelf()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Resize the rectangle
--
-- Parameters:
--  width: The new width (optional)
--  height: the new height (optional)
function Class:resize(options)
	-- Update size
	if options.width then
		self.width = options.width
		self._displayObject.width = self.width
	end

	if options.height then
		self.height = options.height
		self._displayObject.height = self.height
	end

	-- Reposition rectangle
	self._displayObject:setReferencePoint(self.referencePoint)
	self:setPosition(self.position)

	-- Set visible
	self:checkVisibility()
end

-- Set the stroke color
--
-- Parameters:
--  color: The four components of a color, in this order: R, G, B, Alpha
function Class:setStrokeColor(color)
	color[4] = color[4] or 255
	self._displayObject:setStrokeColor(color[1], color[2], color[3], color[4])
end

-- Show the rectangle if its dimensions are positive, hide it otherwise
function Class:checkVisibility()
	self._displayObject.isVisible = self.isVisible and self.width > 0 and self.height > 0
end

-- Set the gradient of the rectangle (note: does not work with cornerRadius and overrides color parameter)
--
-- Parameters: 
--  from: The starting color
--  to: The ending color
--  direction: The direction ("down", "up", "left" or "right")
function Class:setGradient(options)
	local correctedDirection = options.direction

	if options.direction == "left" then
		correctedDirection = "right"
	elseif options.direction == "right" then
		correctedDirection = "left"
	end

	self._displayObject:setFillColor(graphics.newGradient(options.from, options.to, correctedDirection))
end

-----------------------------------------------------------------------------------------

return Class
