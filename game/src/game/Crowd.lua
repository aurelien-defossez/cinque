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

local startPosition = vec2(100, 100)
local idlePosition = vec2(200, 100)
local endPosition = vec2(400, 100)
local inTransition = 1.0
local outTransition = 0.75

local numberPosition = vec2(280, 70)
local numberSize = 96
local numberColor = { 50, 50, 50 }

local positions = {
	vec2(25, 23),
	vec2(45, 25),
	vec2(88, 28),
	vec2(110, 35),
	vec2(66, 30),
	vec2(45, 50),
	vec2(80, 55),
	vec2(100, 60),
	vec2(60, 65)
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
	self.happyPeople = {}

	-- Create group
	self.group = display.newGroup()
	self.group.x = startPosition.x
	self.group.y = startPosition.y
	groups.crowd:insert(self.group)

	local number = options.number
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
			group = self.group,
			position = positions[j],
			referencePoint = display.BottomCenterReferencePoint
		}
	end

	-- Transition
	self.transition = tnt:newTransition(self.group, {
		time = inTransition * 1000,
		x = idlePosition.x,
		y = idlePosition.y
	})

	-- Bind events
	Runtime:addEventListener("happyFace", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("happyFace", self)

	if self.transition then
		self.transition:cancel()
	end

	for index, person in pairs(self.persons) do
		person:destroy()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:hide()
	if self.transition then
		self.transition:cancel()
	end

	-- Transition
	self.transition = tnt:newTransition(self.group, {
		time = outTransition * 1000,
		x = endPosition.x,
		y = endPosition.y,
		onEnd = function(event)
			self:destroy()
		end
	})
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:happyFace(event)
	local rand

	repeat
		rand = math.random(#self.persons)
	until not self.happyPeople[rand]

	self.happyPeople[rand] = true
	self.persons[rand]:play("happy")
end
