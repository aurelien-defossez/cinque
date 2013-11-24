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

local platePosition = vec2(100, 100)
local pizzaPosition = vec2(135, 100)

local innerRadius = 30
local outerRadius = 75

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.position = options.position
	self.goal = options.goal
	self.slices = {}
	self.enabled = true

	-- Create hitboxes
	self.innerCircle = circle(self.position, innerRadius)
	self.outerCircle = circle(self.position, outerRadius)

	-- Create sprites
	self.plateSprite = Sprite.create{
		spriteSet = "plate",
		animation = "idle",
		group = groups.pizza,
		position = platePosition
	}

	self.pizzasprite = Sprite.create{
		spriteSet = "pizza",
		animation = "complete",
		group = groups.pizza,
		position = pizzaPosition
	}

	if config.debug.drawDebug then
		self.innerCircle:draw{ color = { 255, 0, 0 }}
		self.outerCircle:draw{ color = { 0, 255, 0 }}
	end

	-- Bind events
	Runtime:addEventListener("gestureEnded", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("gestureEnded", self)

	for index, slice in pairs(self.slices) do
		slice:destroy()
	end

	self.pizzasprite:destroy()
	self.outerCircle:destroy()
	self.innerCircle:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:disable()
	self.enabled = false
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:gestureEnded(event)
	if self.enabled then
		local points = event.gesture.points
		local firstPoint = points[1]
		local lastPoint = points[#points]
		local sliced = false
		local angle

		-- Detect inward cutting
		if not self.outerCircle:collidePoint(firstPoint) and self.innerCircle:collidePoint(lastPoint) then
			sliced = true
			angle = -(lastPoint - firstPoint):angle()

		-- Detect outward cutting
		elseif self.innerCircle:collidePoint(firstPoint) and not self.outerCircle:collidePoint(lastPoint) then
			sliced = true
			angle = -(lastPoint - firstPoint):angle() + 180
		end

		if sliced then
			self.slices[#self.slices + 1] = Slice.create{
				center = self.position,
				angle = angle
			}

			if #self.slices == self.goal then
				Runtime:dispatchEvent{
					name = "goalAchieved",
					slices = self.slices
				}
			end
		end
	end
end
