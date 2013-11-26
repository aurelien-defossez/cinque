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
            x=72,
            y=202,
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
            -- rating_bad
            x=86,
            y=222,
            width=22,
            height=14,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 21,
            sourceHeight = 13
        },
        {
            -- rating_good
            x=50,
            y=234,
            width=34,
            height=18,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 33,
            sourceHeight = 17
        },
        {
            -- rating_ok
            x=86,
            y=238,
            width=20,
            height=12,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 19,
            sourceHeight = 12
        },
        {
            -- rating_perfect
            x=62,
            y=174,
            width=64,
            height=26,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 63,
            sourceHeight = 25
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
            y=202,
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
