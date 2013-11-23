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
	"Poor"
}

local colors = {
	{ 28, 232, 45 },
	{ 222, 232, 28 },
	{ 200, 198, 247 },
	{ 247, 198, 198 }
}

local sizes = {
	28,
	24,
	20,
	16
}

local textDistance = 75

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.position = options.position
	self.texts = {}

	-- Create timeline
	local timelineDefinition = {}
	local time = 0

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

	for index, text in pairs(self.text) do
		if text then
			text:destroy()
		end
	end

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:showResult(options)
	if options.firstFrame then
		local text = Text.create{
			text = texts[options.parameters.rating],
			color = colors[options.parameters.rating],
			size = sizes[options.parameters.rating],
			group = groups.hud,
			position = self.position + vec2(0, -1):rotate(options.parameters.angle) * textDistance
		}

		self.texts[options.parameters.index] = text
	end

	if options.progress == 1.0 then
		self.texts[options.parameters.index]:destroy()
		self.texts[options.parameters.index] = nil
	end
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

function Class:ecussonEnterFrame(options)
	if not options.paused then
		self.timeline:enterFrame(options)
	end
end
