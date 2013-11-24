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
            x=348,
            y=2,
            width=80,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 100
        },
        {
            -- adrian_idle
            x=132,
            y=206,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 59,
            sourceHeight = 100
        },
        {
            -- alex_happy
            x=244,
            y=410,
            width=50,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 49,
            sourceHeight = 100
        },
        {
            -- alex_idle
            x=192,
            y=410,
            width=50,
            height=100,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 100
        },
        {
            -- francois_happy
            x=2,
            y=2,
            width=126,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 125,
            sourceHeight = 100
        },
        {
            -- francois_idle
            x=192,
            y=308,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 57,
            sourceHeight = 100
        },
        {
            -- fred_happy
            x=430,
            y=2,
            width=76,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 74,
            sourceHeight = 100
        },
        {
            -- fred_idle
            x=2,
            y=410,
            width=66,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 65,
            sourceHeight = 100
        },
        {
            -- geff_happy
            x=2,
            y=308,
            width=66,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 67,
            sourceHeight = 100
        },
        {
            -- geff_idle
            x=132,
            y=410,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
        {
            -- julien_happy
            x=70,
            y=410,
            width=60,
            height=100,

        },
        {
            -- julien_idle
            x=70,
            y=308,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 60,
            sourceHeight = 100
        },
        {
            -- laurent_happy
            x=2,
            y=104,
            width=74,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 73,
            sourceHeight = 100
        },
        {
            -- laurent_idle
            x=2,
            y=206,
            width=66,
            height=100,

        },
        {
            -- louisremi_happy
            x=244,
            y=2,
            width=102,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 101,
            sourceHeight = 100
        },
        {
            -- louisremi_idle
            x=132,
            y=308,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
        {
            -- michael_happy
            x=78,
            y=104,
            width=60,
            height=100,

        },
        {
            -- michael_idle
            x=200,
            y=104,
            width=56,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 100
        },
        {
            -- sarah_happy
            x=130,
            y=2,
            width=112,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 111,
            sourceHeight = 100
        },
        {
            -- sarah_idle
            x=70,
            y=206,
            width=60,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 59,
            sourceHeight = 100
        },
        {
            -- stephane_happy
            x=194,
            y=206,
            width=56,
            height=100,

        },
        {
            -- stephane_idle
            x=140,
            y=104,
            width=58,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 58,
            sourceHeight = 100
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
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
