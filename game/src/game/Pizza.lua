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

local startPosition = vec2(-120, 100)
local startRotation = 0

local idlePosition = vec2(105, 100)
local idleRotation = 0

local endPosition = vec2(-30, 350)
local endRotation = 45

local plateOffset = vec2(-35, 0)
local inDuration = 0.5
local outDuration = 0.5

local innerRadius = 35
local outerRadius = 65

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.goal = options.goal
	self.slices = {}
	self.phase = "showing"
	self.enabled = false

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
	Runtime:addEventListener("gestureStarted", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("gestureStarted", self)

	self.transition:cancel()
	self:disable()

	for index, slice in pairs(self.slices) do
		slice:destroy()
	end

	self.plateSprite:destroy()
	self.pizzasprite:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:getPosition()
	return vec2(self.group.x, self.group.y)
end

function Class:hide(options)
	self.hideCallback = options.onHide
	self.phase = "hiding"
	self:disable()

	self.transition = tnt:newTransition(self.group, {
		time = outDuration * 1000,
		x = endPosition.x,
		y = endPosition.y,
		rotation = endRotation,
		onEnd = self
	})
end

function Class:disable()
	self.enabled = false

	if self.outerCircle then
		self.outerCircle:destroy()
		self.innerCircle:destroy()
		self.outerCircle = nil
		self.innerCircle = nil
	end
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:gestureStarted(event)
	event.gesture:addListener(self)
	self:continueGesture(event.gesture)
end

function Class:continueGesture(gesture)
	if self.enabled and #self.slices < self.goal then
		local points = gesture.points
		local lastPoint = points[#points]
		local innerCollision = self.innerCircle:collidePoint(lastPoint)
		local outerCollision = self.outerCircle:collidePoint(lastPoint)

		if not gesture.started then
			if innerCollision then
				gesture.started = true
				gesture.phasePoint = lastPoint
				gesture.direction = "out"
			elseif outerCollision and #points > 1 and not self.outerCircle:collidePoint(points[#points - 1]) then
				gesture.started = true
				gesture.phasePoint = lastPoint
				gesture.direction = "in"
			end
		end

		if gesture.started then
			if gesture.direction == "out" and not outerCollision then
				gesture.started = false
				self.slices[#self.slices + 1] = Slice.create{
					angle = -(lastPoint - idlePosition):angle() + 180,
					group = self.group
				}
			elseif gesture.direction == "in" and innerCollision then
				gesture.started = false
				self.slices[#self.slices + 1] = Slice.create{
					angle = -(lastPoint - gesture.phasePoint):angle(),
					group = self.group
				}
			end

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
		self.enabled = true

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
