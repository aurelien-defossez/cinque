config = config or {}

-----------------------------------------------------------------------------------------
-- Sprites configuration
--
-- Parameters:
--  frameCount: The number of frames defining the animation (default is 1)
--    If frameCount > 1, then the source images should be suffixed by _01, _02
--    and so on
--    (e.g. zombie_attack_right_blue_01.png and zombie_attack_right_blue_02.png)
--  period: The period in seconds to play the whole animation.
--	  (Optional if there is only one frame)
--  loopCount: Tells how many times the animation loops (Default is 0, indefinitely).
--  attachments: A list of possible attachments to the sprite, with these parameters:
--    animation: The attachment animation
--    positions: The attachment positions relative to the sprite position
--
-----------------------------------------------------------------------------------------

return {
	sheets = {
		main = {
			plate = {
				idle = {}
			},

			pizza = {
				complete = {}
			},

			timer = {
				background = {},
				tick = {}
			},

			effect = {
				slice = {}
			}
		},

		people = {
			adrian = {
				idle = {},
				happy = {},
				sad = {}
			},
			alex = {
				idle = {},
				happy = {},
				sad = {}
			},
			francois = {
				idle = {},
				happy = {},
				sad = {}
			},
			fred = {
				idle = {},
				happy = {},
				sad = {}
			},
			geff = {
				idle = {},
				happy = {},
				sad = {}
			},
			julien = {
				idle = {},
				happy = {},
				sad = {}
			},
			laurent = {
				idle = {},
				happy = {},
				sad = {}
			},
			louisremi = {
				idle = {},
				happy = {},
				sad = {}
			},
			michael = {
				idle = {},
				happy = {},
				sad = {}
			},
			sarah = {
				idle = {},
				happy = {},
				sad = {}
			},
			stephane = {
				idle = {},
				happy = {},
				sad = {}
			}
		}
	},

	-----------------------------------------------------------------------------------------
	-- Sprite attachments configuration
	--
	-- Parameters:
	--  spriteSet: The attachment spriteSet
	--  referencePoint: The reference point (optional, display.CenterReferencePoint by default)
	--  toBack: If true, add the attachment below the sprite (optional, default is false)
	--
	-----------------------------------------------------------------------------------------

	attachments = {
		
	}
}
