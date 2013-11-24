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
            x=4,
            y=348,
            width=4,
            height=152,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 4,
            sourceHeight = 150
        },
        {
            -- pizza_complete
            x=532,
            y=4,
            width=300,
            height=300,

        },
        {
            -- plate_idle
            x=4,
            y=4,
            width=524,
            height=340,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 524,
            sourceHeight = 339
        },
        {
            -- timer_background
            x=12,
            y=348,
            width=108,
            height=116,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 105,
            sourceHeight = 113
        },
        {
            -- timer_tick
            x=124,
            y=348,
            width=16,
            height=52,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 16,
            sourceHeight = 50
        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 512
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
