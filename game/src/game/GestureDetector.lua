-----------------------------------------------------------------------------------------
--
-- GeatureDetector.lua
--
-- Class handling gestures
--
-----------------------------------------------------------------------------------------

local Class = {}
GestureDetector = Class

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the Geature Detector
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.paused = false
	self.gamePaused = false
	self.gestures = {}

	-- Add listeners
	Runtime:addEventListener("ecussonEnterFrame", self)
	Runtime:addEventListener("gamePause", self)
	Runtime:addEventListener("touch", self)
	
	return self
end

-- Destroy the Gesture Detector
function Class:destroy()
	Runtime:removeEventListener("ecussonEnterFrame", self)
	Runtime:removeEventListener("gamePause", self)
	Runtime:removeEventListener("touch", self)

	self:destroyGestures()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Remove the gesture from the list
--
-- Parameters:
--  gesture: The gesture to remove
function Class:removeGesture(gesture)
	self.gestures[gesture.id] = nil
end

-- Pause the gesture detection
function Class:pause()
	self.paused = true
	self:destroyGestures()
end

-- Resume the gesture detection
function Class:resume()
	self.paused = false
end

-- Destroy all gestures
function Class:destroyGestures()
	for eventId, gesture in pairs(self.gestures) do
		gesture:destroy()
	end
end

-----------------------------------------------------------------------------------------
-- Event handlers
-----------------------------------------------------------------------------------------

-- Touch handler
--
-- Parameters:
--  event: The touch event
function Class:touch(event)
	if not self.gamePaused and not self.paused then
		if event.phase == "began" then
			-- Create gesture
			local gesture = Gesture.create{
				parent = self,
				position = vec2(event.x, event.y),
				id = event.id
			}

			self.gestures[event.id] = gesture

			gesture:start()
		else
			-- Update gesture
			local gesture = self.gestures[event.id]

			if gesture then
				gesture:touch(event)
			end
		end

		return true
	end
end

-- Enter frame handler
function Class:ecussonEnterFrame(options)
	for _, gesture in pairs(self.gestures) do
		gesture:enterFrame(options)
	end
end

-- Pause handler
--
-- Parameters:
--  event: The event object, with these data:
--   status: Determines the pause status
function Class:gamePause(event)
	self.gamePaused = event.status

	self:destroyGestures()
end
