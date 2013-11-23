-----------------------------------------------------------------------------------------
-- Sounds configuration
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
--  
-----------------------------------------------------------------------------------------

return {
	
}
