--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:aca2b2155d120f6a57e190a53073a76e:806f852611b91c7d51830c74cc70a325:7b91f048090ec15651888590f1f35b23$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- coin_cent20
            x=50,
            y=234,
            width=18,
            height=18,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 18,
            sourceHeight = 18
        },
        {
            -- coin_cent50
            x=28,
            y=234,
            width=20,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 20,
            sourceHeight = 20
        },
        {
            -- coin_euro
            x=6,
            y=234,
            width=20,
            height=20,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 19,
            sourceHeight = 19
        },
        {
            -- effect_slice
            x=2,
            y=174,
            width=2,
            height=76,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 2,
            sourceHeight = 75
        },
        {
            -- pizza_complete
            x=266,
            y=2,
            width=150,
            height=150,

        },
        {
            -- plate_idle
            x=2,
            y=2,
            width=262,
            height=170,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 262,
            sourceHeight = 169
        },
        {
            -- timer_background
            x=6,
            y=174,
            width=54,
            height=58,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 57
        },
        {
            -- timer_tick
            x=62,
            y=174,
            width=8,
            height=26,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 8,
            sourceHeight = 25
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["coin_cent20"] = 1,
    ["coin_cent50"] = 2,
    ["coin_euro"] = 3,
    ["effect_slice"] = 4,
    ["pizza_complete"] = 5,
    ["plate_idle"] = 6,
    ["timer_background"] = 7,
    ["timer_tick"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
