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

local innerRadius = 30

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.position = options.position
	self.slices = {}

	-- Create sprite
	self.sprite = Sprite.create{
		spriteSet = "pizza",
		animation = "complete",
		group = groups.pizza,
		position = vec2(100, 100)
	}

	if config.debug.drawDebug then
		circle(self.position, innerRadius):draw()
	end

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
	local points = event.gesture.points
	local firstPoint = points[1]
	local lastPoint = points[#points]

	-- Angle when cutting inward
	local angle = -(lastPoint - firstPoint):angle()

	self.sliceEffect = Sprite.create{
		spriteSet = "effect",
		animation = "slice",
		group = groups.slices,
		referencePoint = display.BottomCenterReferencePoint,
		position = self.position + vec2(1, 1):rotate(angle),
		rotation = angle
	}

	print("angle", angle)
end
