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
            x=252,
            y=220,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 118,
            sourceHeight = 200
        },
        {
            -- alex_idle
            x=400,
            y=4,
            width=100,
            height=200,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 110,
            sourceHeight = 200
        },
        {
            -- francois_idle
            x=244,
            y=424,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 114,
            sourceHeight = 200
        },
        {
            -- fred_idle
            x=140,
            y=4,
            width=132,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 129,
            sourceHeight = 200
        },
        {
            -- geff_idle
            x=124,
            y=412,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 116,
            sourceHeight = 200
        },
        {
            -- julien_idle
            x=128,
            y=208,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 121,
            sourceHeight = 200
        },
        {
            -- laurent_idle
            x=4,
            y=4,
            width=132,
            height=200,

        },
        {
            -- louisremi_idle
            x=4,
            y=412,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 116,
            sourceHeight = 200
        },
        {
            -- michael_idle
            x=364,
            y=424,
            width=112,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 111,
            sourceHeight = 200
        },
        {
            -- sarah_idle
            x=4,
            y=208,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 118,
            sourceHeight = 200
        },
        {
            -- stephane
            x=376,
            y=220,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 115,
            sourceHeight = 200
        },
        {
            -- stephane_idle
            x=276,
            y=4,
            width=120,
            height=212,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 121,
            sourceHeight = 210
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 1024
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
