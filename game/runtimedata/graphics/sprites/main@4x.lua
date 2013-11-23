--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9ffd1037efb8bc96cd6deeb18e4b52ff:2e9f6e26c6bfec9d936a098f283f0300:7b91f048090ec15651888590f1f35b23$
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
            y=616,
            width=16,
            height=304,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 10,
            sourceHeight = 300
        },
        {
            -- pizza_complete
            x=8,
            y=8,
            width=600,
            height=600,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["effect_slice"] = 1,
    ["pizza_complete"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
