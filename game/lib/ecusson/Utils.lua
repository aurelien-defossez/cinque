-----------------------------------------------------------------------------------------
--
-- Utils.lua
--
-- Collection of utils functions.
--
-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Local attributes
-----------------------------------------------------------------------------------------

local random = math.random
local min = math.min
local max = math.max
local sin = math.sin
local PI = math.pi
local PI2 = PI * 0.5
local currentId = 0

-----------------------------------------------------------------------------------------
-- Extend math library
-----------------------------------------------------------------------------------------

math.cap = function(value, min, max)
	return max(min, min(value, max))
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Extend a class for inheritance or for instanciation
--
-- Parameters:
--  ParentClass: The class to utils.extend from
-- Returns:
--  The utils.extended object
--
-- Inheritance example:
--  NewClass = utils.extend(ParentClass)
--
-- Instanciation example:
--  local self = utils.extend(Class)
function Class.extend(ParentClass, MetaTable)
	local Class = {}

	-- Create Metatable
	MetaTable = MetaTable or {}
	MetaTable.__index = ParentClass

	setmetatable(Class, MetaTable)

	return Class
end

-- Delete an object by resetting its metatable and setting nil to all its members
--
-- Parameters:
--  object: The object to delete
function Class.deleteObject(object)
	setmetatable(object, {})
	
	for key, _ in pairs(object) do
		object[key] = nil
	end
end

-- Extract a value from a custom parametrable variable
--
-- Parameters:
--  value, a variable which is either:
--   * A number, in which case this value is returned
--   * An array with two values, in which case a random value in this interval is returned
-- Returns:
--  The value, either the numeric value given or a random value comprised in the interval given
function Class.extractValue(value)
	if type(value) == "number" then
		return value
	else
		return value[1] + random() * (value[2] - value[1])
	end
end

-- Get an universal unique id
--
-- Returns:
--  An id not any other object which called getUuid can have
function Class.getUuid()
	currentId = currentId + 1
	return currentId
end

-- Prints the table in the debug console
--
-- Parameters:
--  var: The table
--  name: Its name
--  iteration: The current iteration (internal, do not set)
function Class.printTable(var, name, iteration)
	iteration = iteration or 0

	if iteration < 4 then
		if not name then
			name = "anonymous"
		end

		if type(var) ~= "table" then
			print(name .. " = " .. tostring(var))
		else
			-- for tables, recurse through children
			for k, v in pairs(var) do
				local child

				if type(k) == "string" then
					if string.find(k, "%a[%w_]*") == 1 then
						-- key can be accessed using dot syntax
						child = name .. '.' .. k
					else
						-- key contains special characters
						child = name .. '["' .. k .. '"]'
					end
				else
					child = name .. ".<table>"
				end

				Class.printTable(v, child, iteration + 1)
			end
		end
	end
end

function Class.getTime()
	return system.getTimer() * .001
end

-- Prevent an event from bubbling up
function Class.stopBubbling()
	return true
end

function Class.softError(message)
	if config.debug.crashSoftErrors then
		error(message)
	else
		print(message)
	end
end

function Class.resolveCallback(target, method, event)
	if target then
		event = event or {}

		if type(target) == 'function' then
			return target(event)
		elseif type(target) == 'table' and type(target[method]) == 'function' then
			return target[method](target, event)
		end
	end
end

function Class.interpolateLinear(options)
	return options.from + (options.to - options.from) * options.delta
end

function Class.interpolateSin(options)
	return options.from + (options.to - options.from) * sin(options.delta * PI2)
end

-----------------------------------------------------------------------------------------
-- Enter frame layer
-----------------------------------------------------------------------------------------

-- Enter frame handler
--
-- Parameters:
--  event: The event object
local lastFrameTime = -1
function enterFrameListener(event)
	if lastFrameTime == -1 then
		lastFrameTime = event.time
	else
		local dt = (event.time - lastFrameTime) * .001
		lastFrameTime = event.time

		Runtime:dispatchEvent{
			name = "ecussonEnterFrame",
			dt = dt
		}
	end
end

Runtime:addEventListener("enterFrame", enterFrameListener)

-----------------------------------------------------------------------------------------

return Class
