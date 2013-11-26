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
            x=100,
            y=468,
            width=36,
            height=36,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 36,
            sourceHeight = 35
        },
        {
            -- coin_cent50
            x=56,
            y=468,
            width=40,
            height=40,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 39,
            sourceHeight = 39
        },
        {
            -- coin_euro
            x=12,
            y=468,
            width=40,
            height=40,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 38,
            sourceHeight = 38
        },
        {
            -- effect_slice
            x=4,
            y=348,
            width=4,
            height=152,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 4,
            sourceHeight = 150
        },
        {
            -- pizza_complete
            x=532,
            y=4,
            width=300,
            height=300,

        },
        {
            -- plate_idle
            x=4,
            y=4,
            width=524,
            height=340,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 524,
            sourceHeight = 339
        },
        {
            -- timer_background
            x=12,
            y=348,
            width=108,
            height=116,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 105,
            sourceHeight = 113
        },
        {
            -- timer_tick
            x=124,
            y=348,
            width=16,
            height=52,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 16,
            sourceHeight = 50
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 512
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
