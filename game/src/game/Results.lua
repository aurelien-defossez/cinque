	-----------------------------------------------------------------------------------------
--
-- Results.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
Results = Class

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local timeOffset = 0.25
local duration = 1.0

local texts = {
	"Perfect",
	"Good",
	"OK",
	"Bad"
}

local styles = {
	"perfect",
	"good",
	"ok",
	"poor"
}

local sizes = {
	28,
	24,
	20,
	16
}

local tips = { 100, 50, 20 }

local textDistance = 75
local textStart = vec2(0, 10)
local textEnd = vec2(0, -10)

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.position = options.position
	self.onFinished = options.onFinished
	self.texts = {}

	-- Create timeline
	local timelineDefinition = {}
	local time = 0

	-- Ratings
	for index, result in pairs(options.results) do
		timelineDefinition[#timelineDefinition + 1] = {
			action = "showResult",
			from = time,
			to = time + duration,
			parameters = {
				index = index,
				angle = result.angle,
				rating = result.rating
			}
		}

		time = time + timeOffset
	end

	-- End
	timelineDefinition[#timelineDefinition + 1] = {
		action = "finish",
		at = time + duration
	}

	self.timeline = TimelinePlayer.create{
		timeline = timelineDefinition,
		target = self
	}

	self.timeline:play()

	-- Bind events
	Runtime:addEventListener("ecussonEnterFrame", self)

	return self
end

function Class:destroy()
	Runtime:removeEventListener("ecussonEnterFrame", self)

	for index, text in pairs(self.texts) do
		text:destroy()
	end

	self.timeline:destroy()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:showResult(options)
	if options.firstFrame then
		local text = OutlineText.create{
			style = styles[options.parameters.rating],
			text = texts[options.parameters.rating],
			size = sizes[options.parameters.rating],
			group = groups.hud,
			position = self.position + vec2(0, -1):rotate(options.parameters.angle) * textDistance
		}

		if options.parameters.rating < 4 then
			Runtime:dispatchEvent{
				name = "increaseScore",
				value = tips[options.parameters.rating]
			}
		end

		if options.parameters.rating <= 2 then
			Runtime:dispatchEvent{
				name = "happyFace"
			}
		elseif options.parameters.rating == 4 then
			Runtime:dispatchEvent{
				name = "sadFace"
			}
		end

		self.texts[options.parameters.index] = text
	end

	self.texts[options.parameters.index]:setPosition(
		self.position + vec2(0, -1):rotate(options.parameters.angle) * textDistance
		+ utils.interpolateLinear{
			from = textStart,
			to = textEnd,
			delta = options.progress
		})
end

function Class:finish(options)
	self.onFinished()
	self:destroy()
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:ecussonEnterFrame(options)
	if not options.paused then
		self.timeline:enterFrame(options)
	end
end
