--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:580d861b5554b72e9f9384b8c1cd0433:b07d98abd604c19c2364613453ff83f6:7b91f048090ec15651888590f1f35b23$
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
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["effect_slice"] = 1,
    ["pizza_complete"] = 2,
    ["plate_idle"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
