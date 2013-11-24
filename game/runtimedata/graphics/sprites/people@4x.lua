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
            x=504,
            y=440,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 236,
            sourceHeight = 400
        },
        {
            -- alex_idle
            x=800,
            y=8,
            width=200,
            height=400,

            sourceX = 8,
            sourceY = 0,
            sourceWidth = 219,
            sourceHeight = 400
        },
        {
            -- francois_idle
            x=488,
            y=848,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 227,
            sourceHeight = 400
        },
        {
            -- fred_idle
            x=280,
            y=8,
            width=264,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 258,
            sourceHeight = 400
        },
        {
            -- geff_idle
            x=248,
            y=824,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 231,
            sourceHeight = 400
        },
        {
            -- julien_idle
            x=256,
            y=416,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 241,
            sourceHeight = 400
        },
        {
            -- laurent_idle
            x=8,
            y=8,
            width=264,
            height=400,

        },
        {
            -- louisremi_idle
            x=8,
            y=824,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 231,
            sourceHeight = 400
        },
        {
            -- michael_idle
            x=728,
            y=848,
            width=224,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 221,
            sourceHeight = 400
        },
        {
            -- sarah_idle
            x=8,
            y=416,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 235,
            sourceHeight = 400
        },
        {
            -- stephane
            x=752,
            y=440,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 230,
            sourceHeight = 400
        },
        {
            -- stephane_idle
            x=552,
            y=8,
            width=240,
            height=424,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 241,
            sourceHeight = 420
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 2048
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
