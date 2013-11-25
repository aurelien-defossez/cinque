-----------------------------------------------------------------------------------------
--
-- BonusPoints.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
BonusPoints = Class

-----------------------------------------------------------------------------------------
-- Local configuration
-----------------------------------------------------------------------------------------

local transition = vec2(20, -100)
local duration = 1.0
local alphaDelay = 0.8

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.id = utils.getUuid()
	self.pointsText = OutlineText.create{
		text = "+ "..options.points,
		style = "light",
		group = groups.hud,
		position = options.position,
		numeric = true
	}

	tnt:newTransition(self.pointsText:getDisplayGroup(), {
		time = duration * 1000,
		x = options.position.x + transition.x,
		y = options.position.y + transition.y,
		onEnd = self
	})

	tnt:newTransition(self.pointsText:getDisplayGroup(), {
		time = (duration - alphaDelay) * 1000,
		delay = alphaDelay * 1000,
		alpha = 0
	})

	Runtime:dispatchEvent{
		name = "addRogueElement",
		element = self
	}
	
	return self
end

-- Destroy the mistake
function Class:destroy()
	self.pointsText:destroy()

	Runtime:dispatchEvent{
		name = "removeRogueElement",
		element = self
	}

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- Callback when the mistake is fully transparent
--
-- Parameters:
--  event: The transition event
function Class:transitionEnd(event)
	self:destroy()
end
