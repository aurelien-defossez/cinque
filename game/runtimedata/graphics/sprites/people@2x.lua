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
            x=4,
            y=820,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 118,
            sourceHeight = 200
        },
        {
            -- alex_idle
            x=140,
            y=208,
            width=100,
            height=200,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 110,
            sourceHeight = 200
        },
        {
            -- fred_idle
            x=4,
            y=208,
            width=132,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 129,
            sourceHeight = 200
        },
        {
            -- julien_idle
            x=128,
            y=616,
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
            x=128,
            y=820,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 116,
            sourceHeight = 200
        },
        {
            -- michael_idle
            x=140,
            y=4,
            width=112,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 111,
            sourceHeight = 200
        },
        {
            -- sarah_idle
            x=128,
            y=412,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 118,
            sourceHeight = 200
        },
        {
            -- stephane_idle
            x=4,
            y=412,
            width=120,
            height=212,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 121,
            sourceHeight = 210
        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 1024
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
