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

local numberPosition = vec2(280, 70)
local numberSize = 96
local numberColor = { 50, 50, 50 }

local positions = {
	vec2(225, 73),
	vec2(245, 75),
	vec2(288, 78),
	vec2(310, 85),
	vec2(266, 80),
	vec2(245, 100),
	vec2(280, 105),
	vec2(300, 110),
	vec2(260, 115)
}

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.persons = {}

	return self
end

function Class:destroy()
	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:setCustomers(number)
	local currentPositions = {}
	local positionsFound = 0

	-- Define current positions
	while positionsFound < number do
		local random = math.random(#positions)

		if not currentPositions[random] then
			positionsFound = positionsFound + 1
			currentPositions[random] = true
		end
	end

	local j = 0
	for i = 1, number do
		repeat
			j = j + 1
		until currentPositions[j]

		local person = Sprite.create{
			spriteSet = "alex",
			animation = "idle",
			group = groups.crowd,
			position = positions[j]
		}
	end
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
