-----------------------------------------------------------------------------------------
--
-- OutlineText.lua
--
-----------------------------------------------------------------------------------------

local Class = {}
OutlineText = Class

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

function Class.create(options)
	local colorScheme = config.hud.outline[options.style]
	options.size = (options.size or 24)

	-- Create shadow configuration
	local shadows = {}
	for _, shadow in pairs(config.hud.outline.shadows) do
		shadows[#shadows + 1] = {
			offset = shadow.factorOffset * options.size,
			color = colorScheme.borderColor
		}
	end

	-- Create text
	local self = Text.create(_.extend({
		font = config.hud.outline.font,
		size = 24,
		color = colorScheme.color,
		shadows = shadows
	}, options))

	return self
end
