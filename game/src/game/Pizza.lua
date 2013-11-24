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

local startPosition = vec2(-100, 100)
local startRotation = 0

local idlePosition = vec2(135, 100)
local idleRotation = 0

local endPosition = vec2(0, 300)
local endRotation = 45

local plateOffset = vec2(-35, 0)
local inDuration = 0.5
local outDuration = 0.5

local innerRadius = 30
local outerRadius = 75

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.goal = options.goal
	self.slices = {}
	self.phase = "showing"
	self.enabled = true

	-- Create group
	self.group = display.newGroup()
	self.group.x = startPosition.x
	self.group.y = startPosition.y
	self.group.rotation = startRotation
	groups.pizza:insert(self.group)

	-- Create sprites
	self.plateSprite = Sprite.create{
		spriteSet = "plate",
		animation = "idle",
		group = self.group,
		position = plateOffset
	}

	self.pizzasprite = Sprite.create{
		spriteSet = "pizza",
		animation = "complete",
		group = self.group
	}

	-- Transition
	self.transition = tnt:newTransition(self.group, {
		time = inDuration * 1000,
		x = idlePosition.x,
		y = idlePosition.y,
		rotation = idleRotation,
		onEnd = self
	})

	-- Bind events
	Runtime:addEventListener("gestureEnded", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("gestureEnded", self)

	self.transition:cancel()

	for index, slice in pairs(self.slices) do
		slice:destroy()
	end

	self.pizzasprite:destroy()

	if self.outerCircle then
		self.outerCircle:destroy()
		self.innerCircle:destroy()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:disable()
	self.enabled = false
end

function Class:getPosition()
	return vec2(self.group.x, self.group.y)
end

function Class:hide(options)
	self.hideCallback = options.onHide

	self.phase = "hiding"

	if self.outerCircle then
		self.outerCircle:destroy()
		self.innerCircle:destroy()
		self.outerCircle = nil
		self.innerCircle = nil
	end

	self.transition = tnt:newTransition(self.group, {
		time = outDuration * 1000,
		x = endPosition.x,
		y = endPosition.y,
		rotation = endRotation,
		onEnd = self
	})
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
				angle = angle,
				group = self.group
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

function Class:transitionEnd(event)
	if self.phase == "showing" then
		self.phase = "idle"

		-- Create hitboxes
		self.innerCircle = circle(idlePosition, innerRadius)
		self.outerCircle = circle(idlePosition, outerRadius)

		if config.debug.drawDebug then
			self.innerCircle:draw{ color = { 255, 0, 0 }}
			self.outerCircle:draw{ color = { 0, 255, 0 }}
		end
	elseif self.phase == "hiding" then
		self:hideCallback()
	end
end
