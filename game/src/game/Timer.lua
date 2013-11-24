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
	self.enabled = true
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
	if self.enabled and not options.paused then
		self.time = self.time - options.dt

		if self.time <= 0 then
			self.time = 0
			self.enabled = false

			Runtime:dispatchEvent{
				name = "gameOver"
			}
		end

		self.tick:setRotation(self.time / startTime * 360)
	end
end
