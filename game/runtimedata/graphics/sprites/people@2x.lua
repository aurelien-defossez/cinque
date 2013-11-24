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
            x=696,
            y=4,
            width=160,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 157,
            sourceHeight = 200
        },
        {
            -- adrian_idle
            x=264,
            y=412,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 118,
            sourceHeight = 200
        },
        {
            -- alex_happy
            x=488,
            y=820,
            width=100,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 98,
            sourceHeight = 200
        },
        {
            -- alex_idle
            x=384,
            y=820,
            width=100,
            height=200,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 110,
            sourceHeight = 200
        },
        {
            -- francois_happy
            x=4,
            y=4,
            width=252,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 250,
            sourceHeight = 200
        },
        {
            -- francois_idle
            x=384,
            y=616,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 114,
            sourceHeight = 200
        },
        {
            -- fred_happy
            x=860,
            y=4,
            width=152,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 149,
            sourceHeight = 200
        },
        {
            -- fred_idle
            x=4,
            y=820,
            width=132,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 129,
            sourceHeight = 200
        },
        {
            -- geff_happy
            x=4,
            y=616,
            width=132,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 133,
            sourceHeight = 200
        },
        {
            -- geff_idle
            x=264,
            y=820,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 116,
            sourceHeight = 200
        },
        {
            -- julien_happy
            x=140,
            y=820,
            width=120,
            height=200,

        },
        {
            -- julien_idle
            x=140,
            y=616,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 121,
            sourceHeight = 200
        },
        {
            -- laurent_happy
            x=4,
            y=208,
            width=148,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 145,
            sourceHeight = 200
        },
        {
            -- laurent_idle
            x=4,
            y=412,
            width=132,
            height=200,

        },
        {
            -- louisremi_happy
            x=488,
            y=4,
            width=204,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 201,
            sourceHeight = 200
        },
        {
            -- louisremi_idle
            x=264,
            y=616,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 116,
            sourceHeight = 200
        },
        {
            -- michael_happy
            x=156,
            y=208,
            width=120,
            height=200,

        },
        {
            -- michael_idle
            x=400,
            y=208,
            width=112,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 111,
            sourceHeight = 200
        },
        {
            -- sarah_happy
            x=260,
            y=4,
            width=224,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 222,
            sourceHeight = 200
        },
        {
            -- sarah_idle
            x=140,
            y=412,
            width=120,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 118,
            sourceHeight = 200
        },
        {
            -- stephane_happy
            x=388,
            y=412,
            width=112,
            height=200,

        },
        {
            -- stephane_idle
            x=280,
            y=208,
            width=116,
            height=200,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 115,
            sourceHeight = 200
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
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
