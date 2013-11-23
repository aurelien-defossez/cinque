-----------------------------------------------------------------------------------------
--
-- ImagePreLoader.lua
--
-- A module to pre-load and store image in memory
--
-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the pre loader
function Class.create(options)
    local self = utils.extend(Class)

    -- Initialize attributes
    self.images = {}

	return self
end

-- Destroy the land module
function Class:destroy()
	for path, image in pairs(self.images) do
		self:unload(path)
	end

    utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Load an image
--
-- Parameters:
--  path: The image path
function Class:load(path)
	local image = display.newImageRect(path, 0, 0)
	image.isVisible = false

	self.images[path] = image
end

-- Unload an image
--
-- Parameters:
--  path: The image path
function Class:unload(path)
	self.images[path] = nil
end

-----------------------------------------------------------------------------------------

return Class
