-----------------------------------------------------------------------------------------
--
-- circle.lua
--
-- A circle
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")

-----------------------------------------------------------------------------------------

local Class = {}
local MetaClass = {}

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Build the OBB
local function circle(center, radius)
	local self = utils.extend(Class, MetaClass)

	-- Initialize attributes
	self.center = center
	self.radius = radius

	return self
end

-- Destroy the OBB
function Class:destroy()
	if self.shape then
		self.shape:removeSelf()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Override Methods
-----------------------------------------------------------------------------------------

function MetaClass:__tostring()
	return "[center="..self.center..", radius="..self.radius"]"
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Return true if the circle collide with another circle
function Class:collideCircle(circle)
	return self.center:distance(circle.center) < self.radius + circle.radius
end

-- Return true if the circle collide with a point
function Class:collidePoint(vector)
	return self.center:distance(vector) < self.radius
end

-- Draw shape
function Class:draw(options)
	options = options or {}

	if self.shape then
		self.shape.x = self.center.x
		self.shape.y = self.center.y

		if options.color then
			self.shape:setStrokeColor(unpack(options.color))
		end
	else
		self.shape = display.newCircle(self.center.x, self.center.y, self.radius)
		self.shape:setFillColor(0, 0, 0, 0)
		self.shape:setStrokeColor(255, 0, 255)
		self.shape.strokeWidth = 1
	end
end

-----------------------------------------------------------------------------------------

return circle
