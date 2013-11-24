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
	vec2(225, 123),
	vec2(245, 125),
	vec2(288, 128),
	vec2(310, 135),
	vec2(266, 130),
	vec2(245, 150),
	vec2(280, 155),
	vec2(300, 160),
	vec2(260, 165)
}

local people = {
	"adrian",
	"alex",
	"fred",
	"julien",
	"laurent",
	"louisremi",
	"michael",
	"sarah",
	"stephane"
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
	self:removeCustomers()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:setCustomers(number)
	self:removeCustomers()

	local currentPositions = {}
	local currentPeople = {}
	local peopleAssoc = {}
	local positionsFound = 0
	local peopleFound = 0

	-- Define current positions
	while positionsFound < number do
		local random = math.random(#positions)

		if not currentPositions[random] then
			positionsFound = positionsFound + 1
			currentPositions[random] = true
		end
	end

	-- Define people
	while peopleFound < number do
		local random = people[math.random(#people)]

		if not peopleAssoc[random] then
			peopleFound = peopleFound + 1
			currentPeople[#currentPeople + 1] = random
			peopleAssoc[random] = true
		end
	end

	local j = 0
	for i = 1, number do
		repeat
			j = j + 1
		until currentPositions[j]

		self.persons[#self.persons + 1] = Sprite.create{
			spriteSet = currentPeople[i],
			animation = "idle",
			group = groups.crowd,
			position = positions[j],
			referencePoint = display.BottomCenterReferencePoint
		}
	end
end

function Class:removeCustomers()
	for index, person in pairs(self.persons) do
		person:destroy()
	end

	self.persons = {}
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
