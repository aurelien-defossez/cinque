-----------------------------------------------------------------------------------------
--
-- Class.lua
--
-- Admire the Logo
--
-----------------------------------------------------------------------------------------

local Class = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function Class:createScene(event)
	-- Do nothing
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function Class:destroyScene(event)
	-- Do nothing
end

-- Called immediately after scene has moved onscreen:
function Class:enterScene(event)
	
end

-- Called when scene is about to move offscreen:
function Class:exitScene(event)
	
end

-----------------------------------------------------------------------------------------
-- Binding
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
Class:addEventListener("createScene", Class)

-- "enterScene" event is dispatched whenever scene transition has finished
Class:addEventListener("enterScene", Class)

-- "exitScene" event is dispatched whenever before next scene's transition begins
Class:addEventListener("exitScene", Class)

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
Class:addEventListener("destroyScene", Class)

-----------------------------------------------------------------------------------------

return Class
