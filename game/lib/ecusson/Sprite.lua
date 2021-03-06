-----------------------------------------------------------------------------------------
--
-- Sprite.lua
--
-- An abstract layer over the Corona sprites, used to simplify how it is handled by
-- Corona.
-- It features:
--   The reference point better than legacy Corona
--   The spritePause and spriteChangeSpeed events
--   A lot of other stuff I have to add here
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")
local vec2 = require("lib.ecusson.math.vec2")
local EcussonDisplayObject = require("lib.ecusson.internal.EcussonDisplayObject")

-----------------------------------------------------------------------------------------

local Super = EcussonDisplayObject
local Class = utils.extend(Super)

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local random = math.random

-- The different sets of sprites (e.g. the zombie set contains all animations concerning the zombie)
local sets = {}

-- The different attachments
local attachments = {}

-- The timescale (1 mean normal speed, 0.5 half-speed and 2 double speed)
local timeScale = 1

-- The attachment position factors, to position properly the attachment whichever the sprite's reference point
local attachmentPositionFactors = {}
attachmentPositionFactors[display.TopLeftReferencePoint] = vec2(0.0, 0.0)
attachmentPositionFactors[display.TopCenterReferencePoint] = vec2(0.5, 0.0)
attachmentPositionFactors[display.TopRightReferencePoint] = vec2(1.0, 0.0)
attachmentPositionFactors[display.CenterLeftReferencePoint] = vec2(0.0, 0.5)
attachmentPositionFactors[display.CenterReferencePoint] = vec2(0.5, 0.5)
attachmentPositionFactors[display.CenterRightReferencePoint] = vec2(1.0, 0.5)
attachmentPositionFactors[display.BottomLeftReferencePoint] = vec2(0.0, 1.0)
attachmentPositionFactors[display.BottomCenterReferencePoint] = vec2(0.5, 1.0)
attachmentPositionFactors[display.BottomRightReferencePoint] = vec2(1.0, 1.0)

-----------------------------------------------------------------------------------------
-- Class methods
-----------------------------------------------------------------------------------------

-- Setup sprite library
--
-- Parameters:
--  sheets: The list of sheet names
--  imagePath: The path to the sprite textures
--  datapath: The path to the generated sprite sheet data files
--  animationData: The user-defined animation data,
--  attachments: The attachments definition (optional)
function Class.setup(options)
	attachments = options.attachments

	for _, sheetName in pairs(options.sheets) do
		-- Load sprite sheet data (either with getSheet method or getSpriteSheetData)
		local dataFile = require(options.datapath..sheetName)
		local data = dataFile.getSheet and dataFile:getSheet() or dataFile.getSpriteSheetData()

		-- Create image sheet
		local imageSheet = graphics.newImageSheet(options.imagePath..sheetName..".png", data)

		-- Frame indices (name => index)
		local indexer
		if dataFile.getFrameIndex then
			-- For spritesheets generated with TexturePacker
			indexer = dataFile
		else
			-- For spritesheets generated by a tweaked Zwoptex
			local spriteSheetIndex = {}
			for key, value in pairs(data.frames) do
				spriteSheetIndex[value.name] = key
			end

			-- Create fake class for depecrated Zwoptex format
			indexer = {
				spriteSheetIndex = spriteSheetIndex,

				getFrameIndex = function(self, spriteName)
					return self.spriteSheetIndex[spriteName..".png"]
				end
			}
		end

		-- Load sprite sets
		for setId, sprites in pairs(options.animationData[sheetName]) do
			local animations = {}
			local animationOptions = {}
			local animationCount = 1

			for animationName, animation in pairs(sprites) do
				local variations = animation.variations or {{ suffix = "" }}

				-- Load sprite variations (if any)
				for _, variation in pairs(variations) do
					local suffix = variation.suffix

					-- Frames
					local frames = {}
					if animation.frames then
						for j = 1, #animation.frames do
							local frameIndex = animation.frames[j]
							local zeroedIndex = frameIndex < 10 and "0"..frameIndex or frameIndex
							frames[j] = indexer:getFrameIndex(setId.."_"..animationName..suffix.."_"..zeroedIndex)
						end
					else
						local frameCount = animation.frameCount or 1

						-- Rename sprite as the first sprite of the animation if it is one
						if frameCount == 1 then
							frames = {
								indexer:getFrameIndex(setId.."_"..animationName..suffix)
							}
						else
							for j = 1, frameCount do
								local zeroedIndex = j < 10 and "0"..j or j
								frames[j] = indexer:getFrameIndex(setId.."_"..animationName..suffix.."_"..zeroedIndex)
							end
						end
					end

					-- If this animation is timed, we need to add a second frame to make it work
					if #frames == 1 and animation.period then
						frames[2] = frames[1]
					end

					-- Add the animation to the animations
					animations[animationCount] = {
						name = animationName..suffix,
						frames = frames,
						-- Set the period to 1ms if no period is defined (= steady frame)
						time = animation.period and animation.period * 1000 or 1,
						loopCount = 0,
						loopDirection = "forward"
					}

					animationCount = animationCount + 1
				end

				-- Add the Ecusson specific options
				animationOptions[animationName] = {
					-- Set the loopCount parameter to 0 (loop indefinitely) by default
					loopCount = animation.loopCount or 0,
					-- Set the randomStartFrame parameter to false (not random) by default
					randomStartFrame = animation.randomStartFrame or false,
					variations = animation.variations,
					attachments = animation.attachments or {}
				}
			end

			sets[setId] = {
				imageSheet = imageSheet,
				animations = animations,
				animationOptions = animationOptions
			}
		end
	end
end

-- Sets the animation time scale.
-- A time scale of 1.0 runs the animation at normal speed.
-- A time scale of 2.0 runs the animation twice as fast.
-- A time scale of 0.5 runs the animation at half speed.
--
-- Parameters:
--  newTimeScale: The time scale
function Class.setTimeScale(newTimeScale)
	timeScale = newTimeScale

	Runtime:dispatchEvent{
		name = "spriteChangeSpeed",
		timeScale = newTimeScale
	}
end

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the sprite
--
-- Parameters:
--  spriteSet: The spriteSet name
--  group: The display group to add the sprite to (optional)
--  referencePoint: The reference point (default is display.CenterReferencePoint)
--  position: The position (default is vec2(0, 0))
--  animation: The animation to play
--  rotation: The sprite rotation (default is 0)
--  scale: The uniform scale on both x and y axis (default is 1)
--  opacity: The opacity value, in [0 ; 1] (default is 1)
--  visible: If false, the object will not appear on screen (default is true)
--  toBack: If true, creates the object on back of the group
--  color: The sprite tint
--  mask: The mask to apply to the sprite
--   image: The mask image
--   position: The mask position (default is vec2(0, 0))
--   xScale: The mask x scale (default is 1)
--   yScale: The mask y scale (default is 1)
--   rotation: The mask rotation (default is 0)
--   opacity: The opacity value, in [0 ; 1] (default is 1)
--  autoHide: If true, hide the sprite when the animation ends (default is false)
--  autoDestroy: If true, destroys the sprite when the animation ends (default is false)
function Class.create(options)
	local self = utils.extend(Class)

	-- Initialize attributes
	self.spriteSet = options.spriteSet
	self.autoHide = options.autoHide or false
	self.autoDestroy = options.autoDestroy or false
	self.loopCount = 0
	self.attachments = {}

	-- Create group
	self.group = display.newGroup()
	if options.group then
		options.group:insert(self.group)
	end

	-- Create groups for attachments
	self.backAttachmentsGroup = display.newGroup()
	self.attachmentsGroup = display.newGroup()

	-- Insert back group before the sprite so it's below it
	self.group:insert(self.backAttachmentsGroup)

	-- Create Corona sprite
	local spriteSetDefinition = sets[options.spriteSet]
	if not spriteSetDefinition then
		error("Undefined spriteSet: "..options.spriteSet)
	end
	
	self.spriteSet = options.spriteSet
	self.animationOptions = spriteSetDefinition.animationOptions
	self._displayObject = display.newSprite(spriteSetDefinition.imageSheet, spriteSetDefinition.animations)

	-- Prepare sprite
	self._displayObject.timeScale = timeScale

	-- Apply mask
	if options.mask then
		self:setMask(options.mask)
	end

	Super.super(self, options)

	-- Create factor vector to position attachments relative to the sprite reference point
	self.attachmentPositionFactor = attachmentPositionFactors[self.referencePoint]

	-- Attachments group is inserted after the sprite to make it on front (or reposition it to front directly)
	self.group:insert(self.attachmentsGroup)

	if options.toBack then
		self.attachmentsGroup:toBack()
		self._displayObject:toBack()
	end

	-- Auto play animation
	if options.animation then
		self:play(options.animation)
	end

	-- Listen to events
	Runtime:addEventListener("spritePause", self)
	Runtime:addEventListener("spriteChangeSpeed", self)
	self._displayObject:addEventListener("sprite", self)

	return self
end

-- Destroy the sprite
function Class:destroy()
	self._displayObject:removeEventListener("sprite", self)
	Runtime:removeEventListener("spritePause", self)
	Runtime:removeEventListener("spriteChangeSpeed", self)

	for _, attachment in pairs(self.attachments) do
		attachment:destroy()
	end

	Super.destroy(self)

	self._displayObject:removeSelf()
	self.attachmentsGroup:removeSelf()
	self.backAttachmentsGroup:removeSelf()
	self.group:removeSelf()

	utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Play the given animation
--
-- Parameters:
--  animationName: The animation to play
--  frame: The frame to start the animation on (default is 1)
--  autoDestroy: If true, destroys the sprite when the animation ends
function Class:play(animationName, options)
	options = options or {}
	self.animation = animationName
	self:resume()

	if animationName then
		local currentAnimationOptions = self.animationOptions[animationName]

		if not currentAnimationOptions then
			utils.softError("Undefined sprite animation: "..animationName.." of "..self.spriteSet)
		else
			self.currentAnimationOptions = currentAnimationOptions

			-- Pick random variation
			if self.currentAnimationOptions.variations and #self.currentAnimationOptions.variations > 0 then
				local variations = self.currentAnimationOptions.variations
				local suffix = variations[random(#variations)].suffix
				animationName = animationName..suffix
			end

			-- Prepare sequence (sprite set animation)
			self._displayObject:setSequence(animationName)

			-- Start at a certain frame
			if options.frame then
				self:setFrame(options.frame)
			elseif self.currentAnimationOptions.randomStartFrame then
				self:setFrame(random(self._displayObject.numFrames))
			end
		end
	end

	self._displayObject:play()
	self.isAnimating = true
	self.loopCount = 0

	-- Save attributes
	self.width = self._displayObject.width
	self.height = self._displayObject.height
	self.autoDestroy = options.autoDestroy or self.autoDestroy
	self.autoHideOnce = options.autoHide

	-- Reset position
	self._displayObject:setReferencePoint(self.referencePoint)
	self:setPosition(self.position)

	-- Reposition attachments
	self:repositionAttachments()
end

-- Pause the sprite animation
function Class:pause()
	self.isAnimating = self._displayObject.isPlaying

	if self._displayObject.pause then
		self._displayObject:pause()
	else
		print("Impossible to pause sprite "..self.spriteSet..":"..self.animation..", display object does not exists")
	end
end

-- Resume the sprite animation
function Class:resume()
	if self.isAnimating then
		self._displayObject:play()
	end
end

-- Move the display object to a given position
--
-- Parameters:
--  position: The position
function Class:setPosition(position)
	Super.setPosition(self, position)

	if self.attachmentPositionFactor then
		local attachmentsPosition = position - vec2(self.width, self.height) * self.attachmentPositionFactor

		self.attachmentsGroup.x = attachmentsPosition.x
		self.attachmentsGroup.y = attachmentsPosition.y

		self.backAttachmentsGroup.x = attachmentsPosition.x
		self.backAttachmentsGroup.y = attachmentsPosition.y
	end
end

-- Set the opacity of the display object
--
-- Parameters:
--  opacity: The new opacity
function Class:setOpacity(opacity)
	for _, attachment in pairs(self.attachments) do
		attachment:setOpacity(opacity)
	end

	Super.setOpacity(self, opacity)
end

-- Set the visibility of the display object
--
-- Parameters:
--  visible: if true, the object will be visible
function Class:setVisible(visible)
	for _, attachment in pairs(self.attachments) do
		attachment:setVisible(visible)
	end

	Super.setVisible(self, visible)
end

-- Set a mask on the sprite
--
--  mask: The mask to apply to the sprite
--   image: The mask image
--   position: The mask position (default is vec2(0, 0))
--   xScale: The mask x scale (default is 1)
--   yScale: The mask y scale (default is 1)
--   rotation: The mask rotation (default is 0)
--   opacity: The opacity value, in [0 ; 1] (default is 1)
function Class:setMask(options)
	self._displayObject:setMask(options.image)

	if options.rotation then
		self:setMaskRotation(options.rotation)
	end

	self._displayObject.maskScaleX = 0.25
	self._displayObject.maskScaleY = 0.25

	self:setMaskPosition(options.position or vec2(0, 0))
end

-- Remove the mask from the sprite
function Class:removeMask()
	self._displayObject:setMask(nil)
end

-- Move the sprite mask to a given position
--
-- Parameters:
--  position: The position
function Class:setMaskPosition(position)
	self._displayObject.maskX = position.x
	self._displayObject.maskY = position.y
end

-- Rotate the sprite mask
--
-- Parameters:
--  rotation: the rotation
function Class:setMaskRotation(rotation)
	self._displayObject.maskRotation = rotation
end

-- Set the current frame
--
-- parameters:
--  frame: the frame number, in [ 1 ; nbFrames ]
function Class:setFrame(frame)
	self._displayObject:setFrame(frame)
end

-- Return the current frame number
--
-- Returns:
--  The current frame number, in [ 1 ; nbFrames ]
function Class:getFrame()
	return self._displayObject.frame
end

-- Attach an attachment to the sprite
--
-- Parameters:
--  attachmentName: The attachment to attach
--
-- Returns the attachment
function Class:attach(attachmentName)
	if not self.attachments[attachmentName] then
		local attachmentDefinition = attachments[attachmentName]

		if not attachmentDefinition then
			utils.softError("No definition for attachment "..attachmentName)
		end

		local animationDefinition = self.currentAnimationOptions.attachments[attachmentName]
		local attachment = Sprite.create{
			spriteSet = attachmentDefinition.spriteSet,
			group = attachmentDefinition.toBack and self.backAttachmentsGroup or self.attachmentsGroup,
			referencePoint = attachmentDefinition.referencePoint
		}

		if animationDefinition then
			attachment:play(animationDefinition.animation)
		end

		self.attachments[attachmentName] = attachment

		self:repositionAttachment(attachmentName)

		return attachment
	else
		return self.attachments[attachmentName]
	end
end

-- Detach an attachment previously attached
--
-- Parameters:
--  attachmentName: The attachment to detach
function Class:detach(attachmentName)
	if self.attachments[attachmentName] then
		self.attachments[attachmentName]:destroy()
		self.attachments[attachmentName] = nil
	end
end

-- Return a specific attachment
--
-- Parameters:
--  attachmentName: The attachment to get
function Class:getAttachment(attachmentName)
	return self.attachments[attachmentName]
end

-- Reposition all attachments depending on sprite animation
function Class:repositionAttachments()
	for attachmentName, attachment in pairs(self.attachments) do
		self:repositionAttachment(attachmentName)
	end
end

-- Reposition a specific attachment depending on sprite animation
--
-- Parameters:
--  attachmentName: The attachment to reposition
function Class:repositionAttachment(attachmentName)
	local attachment = self.attachments[attachmentName]
	local attachmentOptions = self.currentAnimationOptions.attachments[attachmentName]

	if attachmentOptions then
		attachment:setVisible(self.isVisible)

		-- For the case we added a false second frame to create a steady timed animation
		local position = attachmentOptions.positions[self:getFrame()]
		if not position then
			position = attachmentOptions.positions[1]
		end

		attachment:setPosition(position)
	else
		attachment:hide()
	end
end

-----------------------------------------------------------------------------------------
-- Event listeners
-----------------------------------------------------------------------------------------

-- Native sprite event handler
--
-- Parameters:
--  event: The event thrown
function Class:sprite(event)
	local currentFrame = self._displayObject.frame
	local loopDetected = false

	self.width = self._displayObject.width
	self.height = self._displayObject.height

	local ecussonPhase
	if event.phase == "next" then
		if currentFrame <= self.lastFrame then
			-- Detect loops not sent by Corona
			loopDetected = true
		else
			-- Dispatch next event
			ecussonPhase = "next"
		end
	elseif event.phase == "began" then
		-- Dispatch began event
		ecussonPhase = "began"
	end

	if event.phase == "loop" or loopDetected then
		-- Count loops and throw either a loop event, if the animation is not finished, or an ended event otherwise
		self.loopCount = self.loopCount + 1

		if self.currentAnimationOptions.loopCount == 0 or self.loopCount < self.currentAnimationOptions.loopCount then
			ecussonPhase = "loop"
		else
			-- Auto-destroy the sprite if ordered so
			if self.autoDestroy then
				self:destroy()
			elseif self.autoHide or self.autoHideOnce then
				self:hide()
				self.autoHideOnce = false
			else
				ecussonPhase = "ended"
				self:setFrame(self.lastFrame)
				self:pause()
			end
		end
	end

	self.lastFrame = currentFrame

	-- Dispatch event
	if ecussonPhase then
		self._displayObject:dispatchEvent{
			name = "ecussonSprite",
			phase = ecussonPhase,
			sprite = self,
			frame = self._displayObject.frame
		}

		-- Move attachments according to sprite animation
		if ecussonPhase == "next" or ecussonPhase == "loop" then
			self:repositionAttachments()
		end
	end
end

-- Pause the sprite animation
--
-- Parameters:
--  event: The tile event, with these values:
--   status: If true, then pauses the animation, otherwise resumes it
function Class:spritePause(event)
	if event.status then
		self:pause()
	else
		self:resume()
	end
end

-- Change the sprite animation speed
--
-- Parameters:
--  event: The event, with these values:
--   timeScale: The new time scale
function Class:spriteChangeSpeed(event)
	self._displayObject.timeScale = event.timeScale
end

-----------------------------------------------------------------------------------------

return Class
