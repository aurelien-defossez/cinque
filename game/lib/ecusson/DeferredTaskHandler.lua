-----------------------------------------------------------------------------------------
--
-- DeferredTaskHandler.lua
--
-- An event handler that piles events for a deferred resolution
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")

-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the deferred event handler
--
-- Parameters:
--  target: The target object that will receive final events
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.target = options.target
	self.listeners = {}
	self.deferreds = {}
	
	return self
end

-- Destroy the handler
function Class:destroy()
	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:addEventListener(source, eventName)
	if self.listeners[eventName] then
		utils.softError("Event listener already attached to this deferred handler "..eventName)
	else
		local function handler(event)
			self:addTask(eventName, event)
		end

		source:addEventListener(eventName, handler)
		self.listeners[eventName] = handler
	end
end

function Class:removeEventListener(source, eventName)
	source:removeEventListener(eventName, self.listeners[eventName])
	self.listeners[eventName] = nil
end

function Class:addTask(taskName, options)
	self.deferreds[#self.deferreds + 1] = {
		name = taskName,
		options = options
	}
end

function Class:resolveTasks()
	-- Immediately create a new deferred stack if some arrive while resolving the current ones
	local currentDeferreds = self.deferreds
	self.deferreds = {}

	for _, deferred in pairs(currentDeferreds) do
		self.target[deferred.name](self.target, deferred.options)
	end

	-- Execute new tasks if any
	if #self.deferreds > 0 then
		self:resolveTasks()
	end
end

-----------------------------------------------------------------------------------------

return Class
