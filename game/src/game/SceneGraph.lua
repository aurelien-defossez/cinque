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


-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the game scene
--
-- Parameters:
--  mode: The game mode
--  difficulty: The difficulty of the arcade mode
--  level: The first level id (optional, default is 1)
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.rogueElements = {}

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
