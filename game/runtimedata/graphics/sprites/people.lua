--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:37786aa9ead86a5bc07186546a5e573a:49440f0c2b5843eae278a6b7d382f497:d50e8d26da77ac2f9a8746caa0fb48dd$
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
            -- adrian_idle
            x=126,
            y=110,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 59,
            sourceHeight = 100
        },
        {
            -- alex_idle
            x=200,
            y=2,
            width=50,
            height=100,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 100
        },
        {
            -- francois_idle
            x=122,
            y=212,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 57,
            sourceHeight = 100
        },
        {
            -- fred_idle
            x=70,
            y=2,
            width=66,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 65,
            sourceHeight = 100
        },
        {
            -- geff_idle
            x=62,
            y=206,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
        {
            -- julien_idle
            x=64,
            y=104,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 60,
            sourceHeight = 100
        },
        {
            -- laurent_idle
            x=2,
            y=2,
            width=66,
            height=100,

        },
        {
            -- louisremi_idle
            x=2,
            y=206,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
        {
            -- michael_idle
            x=182,
            y=212,
            width=56,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 100
        },
        {
            -- sarah_idle
            x=2,
            y=104,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 59,
            sourceHeight = 100
        },
        {
            -- stephane
            x=188,
            y=110,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
        {
            -- stephane_idle
            x=138,
            y=2,
            width=60,
            height=106,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 60,
            sourceHeight = 105
        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["adrian_idle"] = 1,
    ["alex_idle"] = 2,
    ["francois_idle"] = 3,
    ["fred_idle"] = 4,
    ["geff_idle"] = 5,
    ["julien_idle"] = 6,
    ["laurent_idle"] = 7,
    ["louisremi_idle"] = 8,
    ["michael_idle"] = 9,
    ["sarah_idle"] = 10,
    ["stephane"] = 11,
    ["stephane_idle"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
