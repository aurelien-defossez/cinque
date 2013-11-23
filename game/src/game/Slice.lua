-----------------------------------------------------------------------------------------
--
-- Slice.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
Slice = Class

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local offset = vec2(1, 1)

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.center = options.center
	self.angle = options.angle

	-- Create sprite
	self.sprite = Sprite.create{
		spriteSet = "effect",
		animation = "slice",
		group = groups.slices,
		referencePoint = display.BottomCenterReferencePoint,
		position = self.center + offset:rotate(self.angle),
		rotation = self.angle
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
