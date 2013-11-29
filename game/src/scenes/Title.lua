-----------------------------------------------------------------------------------------
--
-- Title.lua
--
-- Title scene
--
-----------------------------------------------------------------------------------------

local Class = storyboard.newScene()

-----------------------------------------------------------------------------------------
-- Local configuration
-----------------------------------------------------------------------------------------

local pizzaStartPosition = vec2(config.hud.screen.halfWidth, -150)
local pizzaEndPosition = vec2(config.hud.screen.halfWidth, 80)
local pizzaRotationSpeed = 3

local titlePosition = vec2(config.hud.screen.halfWidth, 80)
local titleStartScale = 2.0
local titleSize = 48

local madeBySize = 12
local madeByPosition = vec2(config.hud.screen.halfWidth, 170)

local creditsSize = 10
local creditsStartPosition = vec2(config.hud.screen.width + 5, 190)
local creditsEndPosition = vec2(config.hud.screen.width - 1100, 190)
local creditsPeriod = 30.0

local timeline = {
	{
		action = "rotatePizza",
		from = 0.0
	}, {
		action = "fadeIn",
		from = 0.0,
		to = 0.5
	}, {
		action = "showPizza",
		from = 0.45,
		to = 0.8
	}, {
		action = "showTitle",
		from = 1.0,
		to = 1.1
	}, {
		action = "showMadeBy",
		from = 1.2,
		to = 1.5
	}, {
		action = "rollCredits",
		from = 1.5
	}
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
	self.background = Rectangle.create{
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		image = config.paths.scenes.title,
		referencePoint = display.TopLeftReferencePoint,
		group = groups.background
	}

	self.pizza = Sprite.create{
		spriteSet = "pizza",
		animation = "complete",
		position = pizzaPosition,
		group = groups.pizza,
		visible = false
	}

	self.title = OutlineText.create{
		style = "light",
		text = "CINQUE",
		size = titleSize,
		group = groups.hud,
		position = titlePosition,
		opacity = 0.0
	}

	self.madeBy = OutlineText.create{
		style = "light",
		text = "Made by Aurelien Defossez",
		size = madeBySize,
		group = groups.hud,
		position = madeByPosition,
		opacity = 0.0
	}

	self.credits = OutlineText.create{
		style = "light",
		text = "Made alone during the 5th Game Dev Party.                     "..
			"Special Thanks: Adrian, Alex, Francois, Fred, Geff, Julien, Louis-Remi, Michael, Sarah and Stephane.",
		size = creditsSize,
		group = groups.hud,
		position = creditsStartPosition,
		referencePoint = display.CenterLeftReferencePoint
	}

	self.fader = Rectangle.create{
		width = config.hud.screen.width,
		height = config.hud.screen.height,
		color = { 0, 0, 0 },
		referencePoint = display.TopLeftReferencePoint,
		group = groups.fader
	}

	self.timeline = TimelinePlayer.create{
		timeline = timeline,
		target = self
	}

	self.timeline:play()

	-- Bind events
	Runtime:addEventListener("ecussonEnterFrame", self)
	Runtime:addEventListener("touch", self)
end

-- Called when scene is about to move offscreen:
function Class:exitScene(event)
	Runtime:removeEventListener("ecussonEnterFrame", self)
	Runtime:removeEventListener("touch", self)

	self.timeline:destroy()
	self.credits:destroy()
	self.madeBy:destroy()
	self.title:destroy()
	self.pizza:destroy()
	self.background:destroy()
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- Enter frame handler
--
-- Parameters:
--  event: The event object
function Class:ecussonEnterFrame(options)
	self.timeline:enterFrame(options)
end

-- Enter frame handler
--
-- Parameters:
--  event: The event object
function Class:touch(event)
	if event.phase == "ended" then
		storyboard.gotoScene("src.scenes.Game")
	end
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

function Class:fadeIn(options)
	self.fader:setOpacity(1.0 - options.progress)
end

function Class:showPizza(options)
	if options.firstFrame then
		self.pizza:show()
	end

	self.pizza:setPosition(utils.interpolateLinear{
		from = pizzaStartPosition,
		to = pizzaEndPosition,
		delta = options.progress
	})
end

function Class:rotatePizza(options)
	self.pizza:setRotation(options.delta * pizzaRotationSpeed)
end

function Class:showTitle(options)
	self.title:setOpacity(options.progress)
	self.title:setScale(utils.interpolateLinear{
		from = titleStartScale,
		to = 1.0,
		delta = options.progress
	})
end

function Class:showMadeBy(options)
	self.madeBy:setOpacity(options.progress)
end

function Class:rollCredits(options)
	local progress = (options.delta % creditsPeriod) / creditsPeriod

	self.credits:setPosition(utils.interpolateLinear{
		from = creditsStartPosition,
		to = creditsEndPosition,
		delta = progress
	})
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
