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
	-- Initialize attributes
	self.paused = false
	self.taskHandler = DeferredTaskHandler.create{
		target = self
	}
	
	self.sceneGraph = SceneGraph.create{}

	-- Bind events
	Runtime:addEventListener("ecussonEnterFrame", self)
	Runtime:addEventListener("requirePause", self)
	Runtime:addEventListener("key", self)
end

-- Called when scene is about to move offscreen:
function Class:exitScene(event)
	-- Unbind events
	Runtime:removeEventListener("key", self)
	Runtime:removeEventListener("ecussonEnterFrame", self)
	Runtime:removeEventListener("requirePause", self)
	
	self.sceneGraph:destroy()
	self.taskHandler:destroy()
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- Enter frame handler
--
-- Parameters:
--  event: The event object
function Class:ecussonEnterFrame(options)
	local dt = options.dt

	self.sceneGraph:enterFrame{
		dt = dt,
		paused = self.paused
	}

	-- if not self.paused then
	-- 	particleSugar:enterFrame(dt * 1000)
	-- end

	self.taskHandler:resolveTasks()
end
-- Pause handler
--
-- Parameters:
--  event: The event object, with these data:
--   status: Determines the pause status, default is false
function Class:requirePause(event)
	-- Create pause menu
	if not self.paused and event.status then
		-- PauseMenu.create()
	end

	-- Update pause fields
	self.paused = event.status

	-- Pause timers and transitions
	if self.paused then
		tnt:pauseAllTransitions()
		tnt:pauseAllTimers()
	else
		tnt:resumeAllTransitions()
		tnt:resumeAllTimers()
	end

	-- Pause or resume sprite animation
	Runtime:dispatchEvent{
		name = "spritePause",
		status = self.paused
	}

	-- Send game pause event
	Runtime:dispatchEvent{
		name = "gamePause",
		status = self.paused
	}
end

-- Key listener
function Class:key(event)
	if event.keyName == "back" and event.phase == "up" then
		if WindowManager.getWindowCount() > 1 then
			WindowManager.removeTopWindow()
		else
			os.exit()
		end

		-- We caught the event so we return true
		return true
	end

	return false
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
