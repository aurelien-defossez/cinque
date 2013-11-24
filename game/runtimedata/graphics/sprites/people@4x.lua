--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:79405e2d0e98ad49baad0ce7c2e966d0:e559e47c61113970fba26b4bcd898297:d50e8d26da77ac2f9a8746caa0fb48dd$
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
            x=8,
            y=1640,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 236,
            sourceHeight = 400
        },
        {
            -- alex_idle
            x=280,
            y=416,
            width=200,
            height=400,

            sourceX = 8,
            sourceY = 0,
            sourceWidth = 219,
            sourceHeight = 400
        },
        {
            -- fred_idle
            x=8,
            y=416,
            width=264,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 258,
            sourceHeight = 400
        },
        {
            -- julien_idle
            x=256,
            y=1232,
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
            x=256,
            y=1640,
            width=232,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 231,
            sourceHeight = 400
        },
        {
            -- michael_idle
            x=280,
            y=8,
            width=224,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 221,
            sourceHeight = 400
        },
        {
            -- sarah_idle
            x=256,
            y=824,
            width=240,
            height=400,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 235,
            sourceHeight = 400
        },
        {
            -- stephane_idle
            x=8,
            y=824,
            width=240,
            height=424,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 241,
            sourceHeight = 420
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["adrian_idle"] = 1,
    ["alex_idle"] = 2,
    ["fred_idle"] = 3,
    ["julien_idle"] = 4,
    ["laurent_idle"] = 5,
    ["louisremi_idle"] = 6,
    ["michael_idle"] = 7,
    ["sarah_idle"] = 8,
    ["stephane_idle"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
