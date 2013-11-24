-----------------------------------------------------------------------------------------
--
-- Crowd.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
Crowd = Class

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local numberPosition = vec2(280, 100)
local numberSize = 96
local numberColor = { 255, 200, 200 }
-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes

	-- Create text
	self.text = Text.create{
		text = 0,
		position = numberPosition,
		group = groups.hud,
		referencePoint = CenterRightReferencePoint,
		size = numberSize,
		color = numberColor
	}

	return self
end

function Class:destroy()
	self.text:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:setCustomers(number)
	self.text:setText(number)
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:gestureEnded(event)
	local points = event.gesture.points
	local firstPoint = points[1]
	local lastPoint = points[#points]
	local sliced = false
	local angle

	-- Detect inward cutting
	if not self.outerCircle:collidePoint(firstPoint) and self.innerCircle:collidePoint(lastPoint) then
		sliced = true
		angle = -(lastPoint - firstPoint):angle()

	-- Detect outward cutting
	elseif self.innerCircle:collidePoint(firstPoint) and not self.outerCircle:collidePoint(lastPoint) then
		sliced = true
		angle = -(lastPoint - firstPoint):angle() + 180
	end

	if sliced then
		self.slices[#self.slices + 1] = Slice.create{
			center = self.position,
			angle = angle
		}
	end
end
