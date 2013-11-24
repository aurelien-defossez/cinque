--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a119ab0cef1d798aa49a5d85a571e3e1:949890b4f65d8fb5281f28912b715099:7b91f048090ec15651888590f1f35b23$
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
            width=8,
            height=152,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 5,
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
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 512
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
