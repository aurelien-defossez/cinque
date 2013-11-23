-----------------------------------------------------------------------------------------
--
-- Sound.lua
--
-- An abstract layer over the Corona sound library.
-- It features:
--  A cleaner way to handle the sounds
--  Default options defined on startup for fade in, fade out, volume, etc.
--  Auto-reset volume before playing the sound
--  Duration parameter along with fade out
--  Sound variations
--  Pitch modulation
--  Pan sound
--  Use media library instead of audio for Android devices
--
-----------------------------------------------------------------------------------------

local utils = require("lib.ecusson.Utils")

-----------------------------------------------------------------------------------------

local Class = {}

-----------------------------------------------------------------------------------------
-- Main
-----------------------------------------------------------------------------------------

-- Load libraries
local audio = require("audio")
local media = require("media")

-- 'Touch' the audio class to enable it by getting one of its attributes
local totalChannels = audio.totalChannels

-- For panning: ensure correct distance model is being used.
al.DistanceModel(al.INVERSE_DISTANCE_CLAMPED)
al.Listener(al.POSITION, 0, 0, 0)
al.Listener(al.ORIENTATION, 0, 1, 0, 0, 0, 1)

-----------------------------------------------------------------------------------------
-- Class attributes
-----------------------------------------------------------------------------------------

local nativeTimer = timer
local random = math.random
local MATH_PI_180 = math.pi / 180

-- The sounds handles
local sounds = {}

-- The default extension
local platformName = system.getInfo("platformName")

-- Use ogg on Android and m4a on iOS
local defaultExtension = (platformName == "Android" or platformName == "Win") and "mp3" or "mp3"

-- Enable the use of the media library only on iAndroid
local enableMedia = platformName == "Android"

-----------------------------------------------------------------------------------------
-- Class methods
-----------------------------------------------------------------------------------------

-- Setup sounds
--
-- Parameters:
--  soundsPath: The path to the sounds
--  soundsData: The user-defined sound data
function Class.setup(options)
    -- Load sounds
    for soundId, soundOptions in pairs(options.soundsData) do
        -- Default values
        local extension = soundOptions.extension or defaultExtension
        local soundSettings = {
            loops = soundOptions.loops or 0,
            volume = soundOptions.volume or 1,
            duration = soundOptions.duration or nil,
            fadeIn = soundOptions.fadeIn or nil,
            fadeOut = soundOptions.fadeOut or nil,
            pitch = soundOptions.pitch or 1,
            stream = soundOptions.stream or false,
            media = enableMedia and (soundOptions.media or false)
        }

        -- Select the appropriate method to load the sound
        local loadSound
        if soundSettings.stream then
            loadSound = audio.loadStream
        elseif soundSettings.media then
            loadSound = media.newEventSound
        else
            loadSound = audio.loadSound
        end

        -- Load variations
        local variations = {}
        for i, variation in pairs(soundOptions.variations or { "" }) do
            -- Local sound settings
            local localSettings = {}
            for key, value in pairs(soundSettings) do
                localSettings[key] = value
            end

            -- Determine suffix
            local suffix
            if type(variation) == "string" then
                suffix = variation
            else
                suffix = variation.suffix

                -- Override settings
                for key, value in pairs(localSettings) do
                    localSettings[key] = variation[key] or localSettings[key]
                end
            end

            variations[i] = {
                handle = loadSound(options.soundsPath..soundId..suffix.."."..extension),
                loops = localSettings.loops or 0,
                volume = localSettings.volume or 1,
                duration = localSettings.duration or nil,
                fadeIn = localSettings.fadeIn or nil,
                fadeOut = localSettings.fadeOut or nil,
                pitch = localSettings.pitch or 1,
                stream = localSettings.stream or false,
                media = localSettings.media or false
            }
        end

        -- Save sounds
        sounds[soundId] = {
            name = soundId,
            variations = variations
        }
    end
end

-- Free the memory of the sounds
function Class.tearDown()
    -- Stop all audio
    audio.stop()

    -- Dispose of all sounds
    if sounds then
        for _, sound in pairs(sounds) do
            for _, variation in pairs(sound.variations) do
                audio.dispose(variation.handle)
            end
        end
    end

    sounds = {}
end

-----------------------------------------------------------------------------------------
-- Initialization and Destruction
-----------------------------------------------------------------------------------------

-- Create the sound
--
-- Parameters:
--  sound: The sound name
--  stream: If true, streams the sound instead of loading everything in memory
--  media: If true, uses the media library instead of audio tu play this sound on
--    Android devices
--  loops: The number of times you want the audio to loop (Default is 0).
--    Notice that 0 means the audio will loop 0 times which means that the sound
--    will play once and not loop. Continuing that thought, 1 means the audio will
--    play once and loop once which means you will hear the sound a total of
--    2 times. Passing -1 will tell the system to infinitely loop the sample.
--  volume: The volume of this sound, in [0 ; 1] (Default is 1).
--    It can be an interval to pick a random value from.
--  duration: The sound duration in seconds (Default is nil, until the sound is finished).
--    It can be an interval to pick a random value from.
--  fadeIn: The fade in time in seconds, this will cause the system to start playing
--    a sound muted and linearly ramp up to the maximum volume over the specified
--    number of seconds (Default is nil, no fade in).
--    It can be an interval to pick a random value from.
--  fadeOut: The fade out time in seconds, this will cause the system to stop a
--    sound linearly from its level to no volume over the specified
--    number of seconds (Default is nil, no fade out).
--    It can be an interval to pick a random value from.
--  pitch: The pitch to apply on the sound (Default is 1).
--    It can be an interval to pick a random value from.
--  pan: The
--  onSoundComplete: The callback called when the sound has finished playing (optional).
function Class.create(sound, options)
    local self = utils.extend(Class)

    local soundDefinition = sounds[sound]
    options = options or {}

    if audio.freeChannels == 0 then
        print("Sound "..soundDefinition.name.." could not be played because all channels are in use.")
    else
        -- Determine which variation to play
        local variationId = options.variation or random(#soundDefinition.variations)
        local variation = soundDefinition.variations[variationId]
        local duration = options.duration or variation.duration
        local fadeIn = options.fadeIn or variation.fadeIn
        local pitch = options.pitch or variation.pitch
        local volume = options.volume or variation.volume

        -- Initialize attributes
        self.isMedia = options.media or variation.media
        self.isStream = options.stream or variation.stream
        self.fadeOut = options.fadeOut or variation.fadeOut
        self.onComplete = options.onSoundComplete
        self.handle = variation.handle
        self.playing = true

        -- Play sound
        if self.isMedia then
            media.playEventSound(self.handle, system.ResourceDirectory, function(event)
                self.playing = false

                -- Call user callback if any
                utils.resolveCallback(self.onComplete, "onSoundComplete", event)
            end)
        else
            self.channel, self.source = audio.play(self.handle, {
                loops = options.loops or variation.loops,
                fadeIn = fadeIn and utils.extractValue(fadeIn) * 1000 or nil,
                onComplete = function(event)
                    self.playing = false

                    -- Auto rewind
                    audio.rewind(self.handle)

                    -- Call user callback if any
                    utils.resolveCallback(self.onComplete, "onSoundComplete", event)
                end
            })

            -- Initialize sound for panning
            al.Source(self.source, al.ROLLOFF_FACTOR, 1)
            al.Source(self.source, al.REFERENCE_DISTANCE, 2)
            al.Source(self.source, al.MAX_DISTANCE, 4)

            -- Set volume
            if not fadeIn then
                self:setVolume{
                    volume = utils.extractValue(volume)
                }
            end

            -- Set pan
            if options.pan then
                self:pan(options.pan)
            end

            -- Set pitch
            self:setPitch(pitch)

            -- Manual duration handling (to have a proper fade out if any)
            if duration then
                if duration == 0 then
                    self:stop()
                else
                    self.timerId = nativeTimer.performWithDelay(utils.extractValue(duration) * 1000, self)
                end
            end
        end
    end

    return self
end

-- Destroy the sound object
function Class:destroy()
    utils.deleteObject(self)
end

-----------------------------------------------------------------------------------------
-- Methods
-----------------------------------------------------------------------------------------

-- Check if the sound is playing
--
-- Returns true if the sound is currently playing
function Class:isPlaying()
    return self.isPlaying
end

-- Pause the sound
-- Warning: This does not free the channel
function Class:pause()
    if self.isMedia then
        print("Error: Cannot pause a media sound")
    elseif self.channel then
        if self.timerId then
            nativeTimer.pause(self.timerId)
        end

        audio.pause(self.channel)
    end
end

-- Resume the sound
function Class:resume()
    if self.isMedia then
        print("Error: Cannot resume a media sound")
    elseif self.channel then
        if self.timerId then
            nativeTimer.resume(self.timerId)
        end

        audio.resume(self.channel)
    end
end

-- Rewind the sound
function Class:rewind()
    if self.isMedia then
        print("Error: Cannot rewind a media sound")
    elseif self.channel then
        if self.isStream then
            audio.rewind(self.handle)
        else
            audio.rewind{
                channel = self.channel
            }
        end
    end
end

-- Seeks to a time position
--
-- Parameters:
--  time: The time to seek, in milliseconds
function Class:seek(time)
    if self.isMedia then
        print("Error: Cannot seek a media sound")
    elseif self.channel then
        audio.seek(time, {
            channel = self.channel
        })
    end
end

-- Change the volume
--
-- Parameters:
--  volume: The new volume to set, in [0 ; 1]
--  time: The time in milliseconds to fade the volume (default is nil, no fade)
function Class:setVolume(options)
    if self.isMedia then
        print("Error: Cannot set the volume of a media sound")
    elseif self.channel then
        if options.time and options.time > 0 then
            audio.fade{
                channel = self.channel,
                time = utils.extractValue(options.time),
                volume = utils.extractValue(options.volume)
            }
        else
            audio.setVolume(utils.extractValue(options.volume), {
                channel = self.channel
            })
        end
    end
end

-- Change the pitch
--
-- Parameters:
--  pitch: The new pitch value
function Class:setPitch(pitch)
    if self.isMedia then
        print("Error: Cannot change the pitch of a media sound")
    else
        al.Source(self.source, al.PITCH, utils.extractValue(pitch))
    end
end

-- Pan the sound
--
-- Parameters:
--  value: The pan value, in [-1 ; 1]
function Class:pan(value)
    if self.isMedia then
        print("Error: Cannot pan a media sound")
    else
        local radi = (-90 + ((1 + value) * -90)) * MATH_PI_180
        al.Source(self.source, al.POSITION, math.sin(radi), math.cos(radi), 0)
    end
end

-- Stop the sound
--
-- Parameters:
--  fadeOutTime:  The time in seconds to fade out (default is nil, no fade)
function Class:stop(fadeOutTime)
    if self.isMedia then
        print("Error: Cannot stop a media sound")
    elseif self.channel then
        if self.timerId then
            nativeTimer.cancel(self.timerId)
        end

        local fadeOut = fadeOutTime or self.fadeOut

        if fadeOut and fadeOut > 0 then
            audio.fadeOut{
                channel = self.channel,
                time = utils.extractValue(fadeOut) * 1000
            }
        else
            audio.stop(self.channel)
        end
    end
end

-----------------------------------------------------------------------------------------
-- Event handlers
-----------------------------------------------------------------------------------------

-- Event callback for the finished timer used to handle the duration
function Class:timer(event)
    self:stop()
end

-----------------------------------------------------------------------------------------

return Class
