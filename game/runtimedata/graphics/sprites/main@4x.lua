--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4ee93a307aafabb0838533be7bc9d129:b76daeb2bda2a68557742ac78186e375:7b91f048090ec15651888590f1f35b23$
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
            -- effect_slice
            x=8,
            y=696,
            width=8,
            height=304,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 7,
            sourceHeight = 300
        },
        {
            -- pizza_complete
            x=1064,
            y=8,
            width=600,
            height=600,

        },
        {
            -- plate_idle
            x=8,
            y=8,
            width=1048,
            height=680,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 1047,
            sourceHeight = 677
        },
        {
            -- timer_background
            x=24,
            y=696,
            width=216,
            height=232,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 209,
            sourceHeight = 226
        },
        {
            -- timer_tick
            x=248,
            y=696,
            width=32,
            height=104,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 31,
            sourceHeight = 99
        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["effect_slice"] = 1,
    ["pizza_complete"] = 2,
    ["plate_idle"] = 3,
    ["timer_background"] = 4,
    ["timer_tick"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
