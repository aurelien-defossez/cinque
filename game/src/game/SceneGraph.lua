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

local backgroundWidth = 200
local backgroundHeight = 133
local backgroundOffset = vec2(180, 0)

local scorePosition = vec2(215, 190)
local scoreSize = 20
local scoreColor = { 240, 255, 200 }

local minCrowd = 2
local maxCrowd = 9

local tipLimits = { 0.05, 0.10, 0.20 }

local abs = math.abs

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.gestureDetector = GestureDetector.create()
	self.rogueElements = {}
	self.score = 0
	self.taskHandler = DeferredTaskHandler.create{
		target = self
	}

	-- Create background
	self.background = Rectangle.create{
		width = backgroundWidth,
		height = backgroundHeight,
		group = groups.background,
		position = backgroundOffset,
		referencePoint = display.TopLeftReferencePoint,
		image = config.paths.game.background
	}

	self.foreground = Rectangle.create{
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		group = groups.foreground,
		position = vec2(0, 0),
		referencePoint = display.TopLeftReferencePoint,
		image = config.paths.game.foreground
	}

	-- Create crowd
	self.crowd = Crowd.create{}

	-- Create timer
	self.timer = Timer.create{}

	-- Create score
	self.scoreText = OutlineText.create{
		style = "light",
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
	Runtime:addEventListener("increaseScore", self)
	Runtime:addEventListener("gameOver", self)
	
	return self
end

-- Destroy the scene
function Class:destroy()
	Runtime:removeEventListener("addRogueElement", self)
	Runtime:removeEventListener("removeRogueElement", self)
	Runtime:removeEventListener("goalAchieved", self)
	Runtime:removeEventListener("increaseScore", self)
	Runtime:removeEventListener("gameOver", self)

	-- Stop all sounds
	audio.stop()

	-- Destroy rogue elements
	for _, element in pairs(self.rogueElements) do
		element:destroy()
	end

	self.scoreText:destroy()
	self.crowd:destroy()
	self.foreground:destroy()
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
	-- Cleaning
	if self.pizza then
		self.pizza:hide{
			onHide = function()
				self.pizza:destroy()
				self:doSendPizza()
			end
		}
	else
		self:doSendPizza()
	end
end

function Class:doSendPizza()
	self.nbCustomers = math.random(minCrowd, maxCrowd)

	-- Create pizza
	self.pizza = Pizza.create{
		goal = self.nbCustomers
	}

	self.crowd:setCustomers(self.nbCustomers)
end

function Class:increaseScore(options)
	self.score = self.score + options.value
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

	-- Lock gestures
	self.pizza:disable()

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
	local results = {}
	for i = 2, #angles do
		local currentAngle = angles[i]
		local sliceAngle = currentAngle - previousAngle
		local angularError = abs(sliceAngle - goal)
		local result = {
			angle = angles[i - 1] + sliceAngle * 0.5,
			rating = 4
		}

		previousAngle = currentAngle

		for j = 1, #tipLimits do
			if angularError <= goal * tipLimits[j] then
				result.rating = j
				break
			end
		end

		results[#results + 1] = result
	end

	-- Show results
	Results.create{
		results = results,
		position = self.pizza:getPosition(),
		onFinished = function()
			self.taskHandler:addTask("sendPizza")
		end
	}
end

function Class:gameOver(event)

end
