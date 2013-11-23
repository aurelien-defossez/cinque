-----------------------------------------------------------------------------------------
--
-- WindowManager.lua
-- 
-- A window manager to manage the different menu windows on the screen.
-- Windows can stack, and the manager make sure only one is displayed at a time.
-- Windows can be pushed and poped from this stack.
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")

-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local windows = {}

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Add a window to the window stack
--
-- Parameters:
--  window: the window to add
function Class.addWindow(window)
	local lastWindow = Class.getTopWindow()

	if lastWindow then
		lastWindow:hide()
	end

	windows[#windows + 1] = window
end

-- Remove the top window (equivalent to a pop of the windows stack)
function Class.removeTopWindow()
	if table.getn(windows) > 0 then
		local window = table.remove(windows)
		window:destroy()

		local lastWindow = Class.getTopWindow()
		if lastWindow then
			lastWindow:show()
		end
	end
end

-- Remove all windows from the stack
function Class.removeAllWindows()
	while #windows >= 1 do
		Class.removeTopWindow()
	end
end

-- Get the top window
--
-- Return the top window currently displayed
function Class.getTopWindow()
	if #windows > 0 then
		return windows[#windows]
	else
		return nil
	end
end

-- Get the window count 
--
-- Returns the number of windows in the window stack
function Class.getWindowCount()
	return #windows
end

-----------------------------------------------------------------------------------------

return Class
