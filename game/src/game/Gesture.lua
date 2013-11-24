-----------------------------------------------------------------------------------------
--
-- Gesture.lua
--
-- A gesture (tap, push, swipe or circle)
--
-----------------------------------------------------------------------------------------

local Class = {}
Gesture = Class

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the Gesture
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.id = options.id
	self.parent = options.parent
	self.points = { options.position }

	return self
end

-- Destroy the Gesture
function Class:destroy()
	if self.parent.removeGesture then
		self.parent:removeGesture(self)
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Start the gesture
function Class:start()
	-- Dispatch event
	self:dispatch("gestureStarted")
end

-- Dispatch a public gesture event
--
-- Parameters:
--  eventName: The event name (either gestureStarted, gestureContinued, gestureEnded or gestureMissed)
function Class:dispatch(eventName)
	Runtime:dispatchEvent{
		name = eventName,
		gesture = self
	}
end

function Class:addListener(listener)
	self.listener = listener
end

-----------------------------------------------------------------------------------------
-- Event handlers
-----------------------------------------------------------------------------------------

-- Touch handler
--
-- Parameters:
--  event: The touch event
function Class:touch(event)
	-- Add point to list & compute total distance
	local point = vec2(event.x, event.y)
	self.points[#self.points + 1] = point

	if event.phase == "moved" then
		self.listener:continueGesture(self)
	elseif event.phase == "ended" then
		self:endGesture()
	elseif event.phase == "cancelled" then
		self:destroy()
	end

	return true
end

-- End the gesture, dispatch ended event and potentially missed event
function Class:endGesture()
	self:dispatch("gestureEnded")
	self:destroy()
end

-- Enter frame handler
function Class:enterFrame(options)
	if not options.paused then
		-- Do nothing
	end
end
