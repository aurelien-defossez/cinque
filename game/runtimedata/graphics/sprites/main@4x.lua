--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:5acfc7155e18531b8f756e6edc4b3356:588259a3f2ff1de2f4b5e187a25bc313:7b91f048090ec15651888590f1f35b23$
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
            x=288,
            y=808,
            width=72,
            height=72,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 72,
            sourceHeight = 70
        },
        {
            -- coin_cent50
            x=112,
            y=936,
            width=80,
            height=80,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 78
        },
        {
            -- coin_euro
            x=24,
            y=936,
            width=80,
            height=80,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 75,
            sourceHeight = 75
        },
        {
            -- effect_slice
            x=8,
            y=696,
            width=8,
            height=304,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 7,
            sourceHeight = 300
        },
        {
            -- pizza_complete
            x=1064,
            y=8,
            width=600,
            height=600,

        },
        {
            -- plate_idle
            x=8,
            y=8,
            width=1048,
            height=680,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 1047,
            sourceHeight = 677
        },
        {
            -- rating_bad
            x=344,
            y=888,
            width=88,
            height=56,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 82,
            sourceHeight = 53
        },
        {
            -- rating_good
            x=200,
            y=936,
            width=136,
            height=72,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 131,
            sourceHeight = 69
        },
        {
            -- rating_ok
            x=344,
            y=952,
            width=80,
            height=48,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 47
        },
        {
            -- rating_perfect
            x=248,
            y=696,
            width=256,
            height=104,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 250,
            sourceHeight = 99
        },
        {
            -- timer_background
            x=24,
            y=696,
            width=216,
            height=232,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 209,
            sourceHeight = 226
        },
        {
            -- timer_tick
            x=248,
            y=808,
            width=32,
            height=104,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 31,
            sourceHeight = 99
        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["coin_cent20"] = 1,
    ["coin_cent50"] = 2,
    ["coin_euro"] = 3,
    ["effect_slice"] = 4,
    ["pizza_complete"] = 5,
    ["plate_idle"] = 6,
    ["rating_bad"] = 7,
    ["rating_good"] = 8,
    ["rating_ok"] = 9,
    ["rating_perfect"] = 10,
    ["timer_background"] = 11,
    ["timer_tick"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
