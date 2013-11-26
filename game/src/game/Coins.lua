-----------------------------------------------------------------------------------------
--
-- Coins.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
Coins = Class

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local startPosition = vec2(0, 188)
local endPosition = vec2(0, 220)

local coinFirstPosition = vec2(155, 0)
local coinNextPosition = vec2(-20, 0)
local coinStartPosition = vec2(-250, 0)
local inTransition = 0.5
local outTransition = 0.25

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.coins = {}
	self.currentCoinPosition = coinFirstPosition

	-- Create group
	self.group = display.newGroup()
	self.group.x = startPosition.x
	self.group.y = startPosition.y
	groups.coins:insert(self.group)

	return self
end

function Class:destroy()
	for index, coin in pairs(self.coins) do
		coin:destroy()
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:add(value)
	local animation

	if value == 100 then
		animation = "euro"
	elseif value == 50 then
		animation = "cent50"
	elseif value == 20 then
		animation = "cent20"
	end

	-- Create coin
	local coin = Sprite.create{
		spriteSet = "coin",
		animation = animation,
		group = self.group,
		x = coinStartPosition.x,
		y = coinStartPosition.y
	}

	-- Transition
	tnt:newTransition(coin:getDisplayObject(), {
		time = inTransition * 1000,
		x = self.currentCoinPosition.x,
		y = self.currentCoinPosition.y
	})

	self.currentCoinPosition = self.currentCoinPosition + coinNextPosition
end

function Class:hide()
	tnt:newTransition(self.group, {
		time = outTransition * 1000,
		x = endPosition.x,
		y = endPosition.y,
		onEnd = function()
			self:destroy()
		end
	})
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------
