--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:08b1174899af52e2dd7660d778bb5a37:7542db6dc7d6ff86998a7a949aebc000:d50e8d26da77ac2f9a8746caa0fb48dd$
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
            -- adrian_happy
            x=1392,
            y=8,
            width=320,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 313,
            sourceHeight = 400
        },
        {
            -- adrian_idle
            x=528,
            y=824,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 236,
            sourceHeight = 400
        },
        {
            -- alex_happy
            x=976,
            y=1640,
            width=200,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 196,
            sourceHeight = 400
        },
        {
            -- alex_idle
            x=768,
            y=1640,
            width=200,
            height=400,

            sourceX = 8,
            sourceY = 0,
            sourceWidth = 219,
            sourceHeight = 400
        },
        {
            -- francois_happy
            x=8,
            y=8,
            width=504,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 500,
            sourceHeight = 400
        },
        {
            -- francois_idle
            x=768,
            y=1232,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 227,
            sourceHeight = 400
        },
        {
            -- fred_happy
            x=1720,
            y=8,
            width=304,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 297,
            sourceHeight = 400
        },
        {
            -- fred_idle
            x=8,
            y=1640,
            width=264,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 258,
            sourceHeight = 400
        },
        {
            -- geff_happy
            x=8,
            y=1232,
            width=264,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 266,
            sourceHeight = 400
        },
        {
            -- geff_idle
            x=528,
            y=1640,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 231,
            sourceHeight = 400
        },
        {
            -- julien_happy
            x=280,
            y=1640,
            width=240,
            height=400,

        },
        {
            -- julien_idle
            x=280,
            y=1232,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 241,
            sourceHeight = 400
        },
        {
            -- laurent_happy
            x=8,
            y=416,
            width=296,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 290,
            sourceHeight = 400
        },
        {
            -- laurent_idle
            x=8,
            y=824,
            width=264,
            height=400,

        },
        {
            -- louisremi_happy
            x=976,
            y=8,
            width=408,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 402,
            sourceHeight = 400
        },
        {
            -- louisremi_idle
            x=528,
            y=1232,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 231,
            sourceHeight = 400
        },
        {
            -- michael_happy
            x=312,
            y=416,
            width=240,
            height=400,

        },
        {
            -- michael_idle
            x=800,
            y=416,
            width=224,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 221,
            sourceHeight = 400
        },
        {
            -- sarah_happy
            x=520,
            y=8,
            width=448,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 444,
            sourceHeight = 400
        },
        {
            -- sarah_idle
            x=280,
            y=824,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 235,
            sourceHeight = 400
        },
        {
            -- stephane_happy
            x=776,
            y=824,
            width=224,
            height=400,

        },
        {
            -- stephane_idle
            x=560,
            y=416,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 230,
            sourceHeight = 400
        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["adrian_happy"] = 1,
    ["adrian_idle"] = 2,
    ["alex_happy"] = 3,
    ["alex_idle"] = 4,
    ["francois_happy"] = 5,
    ["francois_idle"] = 6,
    ["fred_happy"] = 7,
    ["fred_idle"] = 8,
    ["geff_happy"] = 9,
    ["geff_idle"] = 10,
    ["julien_happy"] = 11,
    ["julien_idle"] = 12,
    ["laurent_happy"] = 13,
    ["laurent_idle"] = 14,
    ["louisremi_happy"] = 15,
    ["louisremi_idle"] = 16,
    ["michael_happy"] = 17,
    ["michael_idle"] = 18,
    ["sarah_happy"] = 19,
    ["sarah_idle"] = 20,
    ["stephane_happy"] = 21,
    ["stephane_idle"] = 22,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
