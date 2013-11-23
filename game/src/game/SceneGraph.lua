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

local scorePosition = vec2(300, 20)
local scoreSize = 20
local scoreColor = { 240, 255, 200 }

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.gestureDetector = GestureDetector.create()
	self.rogueElements = {}

	-- Create background
	self.background = Rectangle.create{
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		group = groups.background,
		position = vec2(0, 0),
		referencePoint = display.TopLeftReferencePoint,
		image = config.paths.game.background
	}

	-- Create pizzas
	self.pizza = Pizza.create{
		position = vec2(100, 100)
	}

	-- Create crowd
	self.crowd = Crowd.create{}

	-- Create score
	self.score = Text.create{
		text = 0,
		position = scorePosition,
		group = groups.hud,
		referencePoint = CenterRightReferencePoint,
		size = scoreSize,
		color = scoreColor
	}

	Runtime:addEventListener("addRogueElement", self)
	Runtime:addEventListener("removeRogueElement", self)
	
	return self
end

-- Destroy the scene
function Class:destroy()
	Runtime:removeEventListener("addRogueElement", self)
	Runtime:removeEventListener("removeRogueElement", self)

	-- Stop all sounds
	audio.stop()

	-- Destroy rogue elements
	for _, element in pairs(self.rogueElements) do
		element:destroy()
	end

	self.score:destroy()
	self.crowd:destroy()
	self.background:destroy()
	self.pizza:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

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
