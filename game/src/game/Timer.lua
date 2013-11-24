-----------------------------------------------------------------------------------------
--
-- Timer.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
Timer = Class

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local timerPosition = vec2(290, 180)
local tickOffset = vec2(-0.5, -4)

local startTime = 60

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.time = startTime

	-- Create sprite
	self.background = Sprite.create{
		spriteSet = "timer",
		animation = "background",
		position = timerPosition,
		group = groups.timer
	}

	self.tick = Sprite.create{
		spriteSet = "timer",
		animation = "tick",
		position = timerPosition + tickOffset,
		group = groups.timer
	}

	-- Bind events
	Runtime:addEventListener("ecussonEnterFrame", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("ecussonEnterFrame", self)

	self.tick:destroy()
	self.background:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:ecussonEnterFrame(options)
	if not options.paused then
		self.time = self.time - options.dt

		self.tick:setRotation(self.time / startTime * 360)
	end
end
