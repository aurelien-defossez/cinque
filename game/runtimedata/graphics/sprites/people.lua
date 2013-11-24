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
            x=2,
            y=410,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 59,
            sourceHeight = 100
        },
        {
            -- alex_idle
            x=70,
            y=104,
            width=50,
            height=100,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 100
        },
        {
            -- fred_idle
            x=2,
            y=104,
            width=66,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 65,
            sourceHeight = 100
        },
        {
            -- julien_idle
            x=64,
            y=308,
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
            x=64,
            y=410,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
        {
            -- michael_idle
            x=70,
            y=2,
            width=56,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 100
        },
        {
            -- sarah_idle
            x=64,
            y=206,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 59,
            sourceHeight = 100
        },
        {
            -- stephane_idle
            x=2,
            y=206,
            width=60,
            height=106,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 60,
            sourceHeight = 105
        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 512
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
