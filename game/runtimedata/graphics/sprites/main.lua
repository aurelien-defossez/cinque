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
            x=2,
            y=174,
            width=2,
            height=76,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 2,
            sourceHeight = 75
        },
        {
            -- pizza_complete
            x=266,
            y=2,
            width=150,
            height=150,

        },
        {
            -- plate_idle
            x=2,
            y=2,
            width=262,
            height=170,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 262,
            sourceHeight = 169
        },
        {
            -- timer_background
            x=6,
            y=174,
            width=54,
            height=58,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 52,
            sourceHeight = 57
        },
        {
            -- timer_tick
            x=62,
            y=174,
            width=8,
            height=26,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 8,
            sourceHeight = 25
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 256
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
