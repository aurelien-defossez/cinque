-----------------------------------------------------------------------------------------
--
-- Chunk.lua
--
-- A chunk of the life bar
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")
local vec2 = require("lib.ecusson.math.vec2")

-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the chunk
--
-- Parameters:
--  target: The display object target
--  associatedObject: The associated object to destroy on completion (optional)
--  startVelocity: The starting velocity, a vec2 in px/s
--  acceleration: The acceleration, a vec2 in px/s
--  rotation: The rotation speed, in degrees/s (optional, default is nil)
--  lifetime: Maximal duration of the chunk (optional, default is nil)
--  fade: The fade out duration, if any (optional, default is nil)
--  autoRotate: If true, rotates the sprite according to the direction (optional, default is false)
--  pausable: Pauses the chunk movement while in pause (optional, default is true)
--  userdata: A user data array
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.id = utils.getUuid()
	self.target = options.target
	self.associatedObject = options.associatedObject
	self.velocity = options.startVelocity
	self.acceleration = options.acceleration
	self.rotation = options.rotation or 0
	self.lifetime = options.lifetime
	self.duration = 0
	self.fade = options.fade
	self.autoRotate = options.autoRotate
	self.userdata = options.userdata or {}

	if options.pausable ~= nil then
		self.pausable = options.pausable
	else
		self.pausable = true
	end

	Runtime:dispatchEvent{
		name = "addRogueElement",
		element = self
	}
	
	return self
end

-- Destroy the chunk
function Class:destroy()
	Runtime:dispatchEvent{
		name = "removeRogueElement",
		element = self
	}

	if self.associatedObject then
		self.associatedObject:destroy()
	else
		self.target:removeSelf()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- Enter frame handler
function Class:enterFrame(options)
	if not options.paused or not self.pausable then
		self.duration = self.duration + options.dt

		-- Early destroy
		if self.lifetime and self.duration >= self.lifetime then
			self:destroy()
			return
		end

		self.velocity = self.velocity + self.acceleration * options.dt
		self.target.x = self.target.x + self.velocity.x * options.dt
		self.target.y = self.target.y + self.velocity.y * options.dt

		-- Rotate
		if self.autoRotate then
			self.target.rotation = 90 - self.velocity:angle()
		elseif self.rotation then
			self.target.rotation = self.target.rotation + self.rotation * options.dt
		end

		-- Fade out
		if self.fade then
			local opacity = 1 - (self.duration / self.fade)

			if opacity > 0 then
				self.target.alpha = opacity
			else
				self:destroy()
				return
			end
		end

		-- Remove chunk sprite once they out of screen
		if not vec2(self.target.x, self.target.y):isInRectangle(-2 * self.target.width, -2 * self.target.height,
				display.contentWidth + 4 * self.target.width, display.contentHeight + 4 * self.target.height) then
			self:destroy()
		end
	end
end

-----------------------------------------------------------------------------------------

return Class
