-----------------------------------------------------------------------------------------
--
-- SceneGraph.lua
--
-- The game scene is the main game class.
-- It contains all entities, either graphical or non-graphical (e.g. the players).
--
-----------------------------------------------------------------------------------------

local Class = {}
SceneGraph = Class

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

local audio = require("audio")

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local scorePosition = vec2(280, 20)
local scoreSize = 20
local scoreColor = { 240, 255, 200 }

local levels = { 2, 3, 4, 5, 6, 7, 8, 9 }
local tipLimits = { 0.02, 0.05, 0.10 }
local tips = {
	{ 000, 000, 000 },	-- 1
	{ 005, 010, 020 },	-- 2
	{ 020, 050, 100 },	-- 3
	{ 010, 010, 020 },	-- 4
	{ 050, 100, 200 },	-- 5
	{ 020, 050, 100 },	-- 6
	{ 100, 200, 500 },	-- 7
	{ 020, 050, 100 },	-- 8
	{ 100, 200, 500 },	-- 9
	{ 050, 100, 200 },	-- 10
}

local abs = math.abs

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.gestureDetector = GestureDetector.create()
	self.rogueElements = {}
	self.currentLevel = 1
	self.score = 0
	self.taskHandler = DeferredTaskHandler.create{
		target = self
	}

	-- Create background
	self.background = Rectangle.create{
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		group = groups.background,
		position = vec2(0, 0),
		referencePoint = display.TopLeftReferencePoint,
		image = config.paths.game.background
	}

	-- Create crowd
	self.crowd = Crowd.create{}

	-- Create score
	self.scoreText = Text.create{
		position = scorePosition,
		group = groups.hud,
		referencePoint = display.CenterReferencePoint,
		size = scoreSize,
		color = scoreColor
	}

	-- Start game
	self:updateScore()
	self:sendPizza()

	Runtime:addEventListener("addRogueElement", self)
	Runtime:addEventListener("removeRogueElement", self)
	Runtime:addEventListener("goalAchieved", self)
	
	return self
end

-- Destroy the scene
function Class:destroy()
	Runtime:removeEventListener("addRogueElement", self)
	Runtime:removeEventListener("removeRogueElement", self)
	Runtime:removeEventListener("goalAchieved", self)

	-- Stop all sounds
	audio.stop()

	-- Destroy rogue elements
	for _, element in pairs(self.rogueElements) do
		element:destroy()
	end

	self.scoreText:destroy()
	self.crowd:destroy()
	self.background:destroy()
	self.taskHandler:destroy()

	if self.pizza then
		self.pizza:destroy()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:sendPizza()
	self.nbCustomers = levels[self.currentLevel]

	-- Cleaning
	if self.pizza then
		self.pizza:destroy()
	end

	-- Create pizza
	self.pizza = Pizza.create{
		position = vec2(100, 100),
		goal = self.nbCustomers
	}

	self.crowd:setCustomers(self.nbCustomers)
	self.currentLevel = self.currentLevel + 1
end

function Class:increaseScore(value)
	self.score = self.score + value
	self:updateScore()
end

function Class:updateScore()
	local zeroes = ""

	if self.score == math.floor(self.score * 0.1) * 10 then
		zeroes = zeroes .. "0"
	end

	if self.score == math.floor(self.score * 0.01) * 100 then
		zeroes = "." .. zeroes .. "0"
	end

	self.scoreText:setText(self.score * 0.01 .. zeroes)
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- Enter frame handler
function Class:enterFrame(options)
	for elementId, element in pairs(self.rogueElements) do
		if not element.id then
			utils.softError("Rogue element "..elementId.." missing.")
		end

		if element.enterFrame then
			element:enterFrame(options)
		end
	end

	self.taskHandler:resolveTasks()
end

-- Add a rogue element to the scene
--
-- Parameters:
--  event: The event
--   element: The rogue element
function Class:addRogueElement(event)
	self.rogueElements[event.element.id] = event.element
end

-- Remove a rogue element from the scene
--
-- Parameters:
--  event: The event
--   element: The rogue element
function Class:removeRogueElement(event)
	self.rogueElements[event.element.id] = nil
end

function Class:goalAchieved(event)
	local goal = 360 / self.nbCustomers
	local angles = {}

	-- Normalize angles
	for index, slice in pairs(event.slices) do
		local angle = slice.angle

		if angle < 0 then
			angle = angle + 360
		end

		angles[index] = angle
	end

	-- Sort angles
	angles = _.sort(angles, function(a, b)
		return a < b
	end)

	-- Add final angle to complete circle and compute final slice correctly
	angles[#angles + 1] = angles[1] + 360

	-- Determine tips
	local previousAngle = angles[1]
	for i = 2, #angles do
		local sliceAngle = angles[i] - previousAngle
		local angularError = abs(sliceAngle - goal)
		previousAngle = angles[i]

		if angularError <= goal * tipLimits[1] then
			self:increaseScore(tips[self.nbCustomers][3])
			print("Perfect!")
		elseif angularError <= goal * tipLimits[2] then
			self:increaseScore(tips[self.nbCustomers][2])
			print("Good!")
		elseif angularError <= goal * tipLimits[3] then
			self:increaseScore(tips[self.nbCustomers][1])
			print("OK")
		else
			print("Poor")
		end
	end

	-- Send next pizza
	self.taskHandler:addTask("sendPizza")
end
