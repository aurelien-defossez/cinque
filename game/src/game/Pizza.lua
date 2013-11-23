-----------------------------------------------------------------------------------------
--
-- Pizza.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
Pizza = Class

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.sprite = Sprite.create{
		spriteSet = "pizza",
		animation = "complete",
		position = vec2(100, 100)
	}

	-- Bind events
	Runtime:addEventListener("gestureEnded", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("gestureEnded", self)

	self.sprite:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:gestureEnded(event)
	print("gestureEnded")
end
