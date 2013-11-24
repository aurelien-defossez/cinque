-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")

-----------------------------------------------------------------------------------------
-- Imports
-----------------------------------------------------------------------------------------

-- Math lib
vec2 = require("lib.ecusson.math.vec2")
aabb = require("lib.ecusson.math.aabb")
obb = require("lib.ecusson.math.obb")
circle = require("lib.ecusson.math.circle")

-- Config
config = {
	debug = require("src.config.Debug"),
	game = require("src.config.Game"),
	hud = require("src.config.Hud"),
	paths = require("src.config.Paths"),
	sounds = require("src.config.Sounds"),
	sprites = require("src.config.Sprites")
}

-- Ecusson lib
utils = require("lib.ecusson.Utils")
EventAttacher = require("lib.ecusson.EventAttacher")
DeferredTaskHandler = require("lib.ecusson.DeferredTaskHandler")
ImagePreLoader = require("lib.ecusson.ImagePreLoader")
Rectangle = require("lib.ecusson.Rectangle")
Sound = require("lib.ecusson.Sound")
Sprite = require("lib.ecusson.Sprite")
Text = require("lib.ecusson.Text")
Chunk = require("lib.ecusson.Chunk")
MenuWindow = require("lib.ecusson.MenuWindow")
MenuButton = require("lib.ecusson.MenuButton")
WindowManager = require("lib.ecusson.WindowManager")
TimelinePlayer = require("lib.ecusson.TimelinePlayer")
PerformanceWidget = require("lib.ecusson.PerformanceWidget")

-- External libs
storyboard = require("storyboard")
_ = require("lib.underscore")
tnt = require("lib.tnt")
particleSugar = require("lib.particleSugar.ParticleSugar").instance()
blackBox = require("lib.blackBoxBeta")

-----------------------------------------------------------------------------------------
-- Debug
-----------------------------------------------------------------------------------------

-- Jump 30 lines in the debug console
for i = 1, 30 do
	print("")
end

-----------------------------------------------------------------------------------------
-- Globals
-----------------------------------------------------------------------------------------

-- Create groups
groups = {
	background = display.newGroup(),
	pizza = display.newGroup(),
	hud = display.newGroup()
}

-----------------------------------------------------------------------------------------
-- Black Box
-----------------------------------------------------------------------------------------

blackBox.init()

-----------------------------------------------------------------------------------------
-- Image preloader module
-----------------------------------------------------------------------------------------

preloader = ImagePreLoader.create()

-----------------------------------------------------------------------------------------
-- Borders
-----------------------------------------------------------------------------------------

local borders = {
	-- Left border
	Rectangle.create{
		group = groups.borders,
		color = config.hud.borders.color,
		referencePoint = display.TopRightReferencePoint,
		width = config.hud.borders.width,
		height = config.hud.screen.height
	},
	-- Right border
	Rectangle.create{
		group = groups.borders,
		color = config.hud.borders.color,
		referencePoint = display.TopLeftReferencePoint,
		width = config.hud.borders.width,
		height = config.hud.screen.height,
		position = vec2(config.hud.screen.width, 0)
	},
	-- Top border
	Rectangle.create{
		group = groups.borders,
		color = config.hud.borders.color,
		referencePoint = display.BottomLeftReferencePoint,
		width = config.hud.screen.width,
		height = config.hud.borders.width
	},
	-- Bottom border
	Rectangle.create{
		group = groups.borders,
		color = config.hud.borders.color,
		referencePoint = display.TopLeftReferencePoint,
		width = config.hud.screen.width,
		height = config.hud.borders.width,
		position = vec2(0, config.hud.screen.height)
	}
}

-----------------------------------------------------------------------------------------
-- FPS
-----------------------------------------------------------------------------------------

if config.debug.showFPS then
	local performanceWidget = PerformanceWidget.create{
		position = vec2(0, config.hud.screen.height - 15),
		group = groups.debug
	}
end

-----------------------------------------------------------------------------------------
-- Local methods
-----------------------------------------------------------------------------------------

-- Pauses the game
--
-- Parameters:
--  pauseStatus: True if the game has to be paused, false to resume
local pause = function(pauseStatus)
	Runtime:dispatchEvent{
		name = "requirePause",
		status = pauseStatus
	}
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- System event listener
local systemEventListener = function(event)
	print("System event: "..event.type)

	if event.type == "applicationStart" then
		-- Seed randomizer
		math.randomseed(os.time())

		-- Start the multiplayer game
		storyboard.gotoScene("src.scenes.Loading")
	elseif event.type == "applicationExit" then
		-- Unload sounds
		Sound.tearDown()

		-- Delete performance widget
		if performanceWidget then
			performanceWidget:destroy()
		end

		-- Delete borders
		for i = 1, #borders do
			borders[i]:destroy()
		end

		-- Delete groups
		for i = 1, #groups do
			groups[i]:removeSelf()
		end

		return true
	elseif event.type == "applicationSuspend" then
		pause(true)
		return true
	end

	return false
end

-- Setup a system event listener
Runtime:addEventListener("system", systemEventListener)
