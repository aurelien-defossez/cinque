-----------------------------------------------------------------------------------------
--
-- Class.lua
--
-- Admire the Logo
--
-----------------------------------------------------------------------------------------

local Class = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local classes = {
	"src.hud.OutlineText",

	"src.game.Pizza",
	"src.game.Slice",
	"src.game.Crowd",
	"src.game.Coins",
	"src.game.Timer",
	"src.game.SceneGraph",
	"src.game.GestureDetector",
	"src.game.Gesture",
	"src.game.Results"
}

local phases = {
	"code",
	"sounds",
	"spritesheets",
	"images"
}

local sheets = { "main", "people" }

local images = {
	config.paths.game.background,
	config.paths.game.foreground
}

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
	self.fadingIn = true
	self.fadingOut = false
	self.preLoaded = false

	-- Draw background
	self.background = Rectangle.create{
		group = groups.background,
		referencePoint = display.TopLeftReferencePoint,
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		color = config.hud.logo.backgroundColor
	}

	-- Draw logo
	self.logo = Rectangle.create{
		image = config.paths.scenes.logo,
		group = groups.background,
		referencePoint = display.TopLeftReferencePoint,
		width = config.hud.logo.width,
		height = config.hud.logo.height
	}

	self.logo:setPosition(config.hud.logo.offset + vec2(
		(config.hud.screen.width - self.logo.width) * .5,
		(config.hud.screen.height - self.logo.height) * .5))

	-- Draw fader
	self.fader = Rectangle.create{
		group = groups.fader,
		referencePoint = display.TopLeftReferencePoint,
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		color = { 0, 0, 0 }
	}

	-- Fade fader
	tnt:newTransition(self.fader:getDisplayObject(), {
		time = config.debug.noLoading and 0 or config.hud.loading.fadeIn * 1000,
		alpha = 0,
		onEnd = self
	})

	-- Initialize screen dimension for menus
	MenuWindow.initializeDimensions{
		width = config.hud.screen.width,
		height = config.hud.screen.height
	}

	-- Initialize windows style
	MenuWindow.setDefaults(config.hud.windows)
	MenuButton.setDefaults(config.hud.buttons)

	-- Add the key callback
	Runtime:addEventListener("enterFrame", self)
	Runtime:addEventListener("key", self)
end

-- Called when scene is about to move offscreen:
function Class:exitScene(event)
	Runtime:removeEventListener("enterFrame", self)
	Runtime:removeEventListener("key", self)

	self.fader:destroy()
	self.logo:destroy()
	self.background:destroy()
end
-----------------------------------------------------------------------------------------
-- Callbacks
-----------------------------------------------------------------------------------------

-- Callback when the fader transition ends
--
-- Parameters:
--  event: The transition event
function Class:transitionEnd(event)
	if self.fadingIn then
		self.fadingIn = false
		self.phase = 1
		tnt:newTimer(config.debug.noLoading and 1 or config.hud.loading.idle * 1000, self)
	else
		storyboard.gotoScene("src.scenes.Game")
	end
end

-- Callback when the timer ends
--
-- Parameters:
--  event: The timer event
function Class:timerEnd(event)
	self.fadeOutReady = true
end

-- Enter frame listener
function Class:enterFrame(event)
	if not self.preLoaded then
		if phases[self.phase] == "code" then
			print("Preload code")

			-- Pre-load code
			for _, class in pairs(classes) do
				require(class)
			end

			self.phase = self.phase + 1
		elseif phases[self.phase] == "sounds" then
			print("Preload sounds")

			-- Pre-load sounds
			Sound.setup{
				soundsPath = config.paths.sounds,
				soundsData = config.sounds
			}

			self.phase = self.phase + 1
		elseif phases[self.phase] == "spritesheets" then
			print("Preload spritesheets")

			-- Pre-load sprites
			Sprite.setup{
				sheets = sheets,
				imagePath = config.paths.spritesheet.texture,
				datapath = config.paths.spritesheet.data,
				animationData = config.sprites.sheets,
				attachments = config.sprites.attachments
			}

			self.phase = self.phase + 1
		elseif phases[self.phase] == "images" then
			if not self.image then
				self.image = 1
			end

			print("Preload image "..images[self.image])

			-- Pre-load image
			preloader:load(images[self.image])

			self.image = self.image + 1

			if self.image > #images then
				self.preLoaded = true
			end
		end
	elseif self.fadeOutReady and not self.fadingOut then
		self.fadingOut = true
		tnt:newTransition(self.fader:getDisplayObject(), {
			time = config.debug.noLoading and 0 or config.hud.loading.fadeOut * 1000,
			alpha = 1,
			onEnd = self
		})
	end
end

-- Key listener
function Class:key(event)
	if event.keyName == "back" and event.phase == "up" then
		os.exit()
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
