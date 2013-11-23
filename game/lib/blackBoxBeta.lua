

local blackBox = {}
  local widget = require('widget')
  local gesture
  local function loadGesture()
    gesture = require('gesture')
  end
  local paramsVar = require('lib.bbConfig')
  if type(paramsVar) ~= "table" then paramsVar = {} end
if not(pcall(loadGesture)) then gesture = "" end
----------------------------------------------------------------------------------
-- VARIABLES
  local _api = { newGroup = display.newGroup,
                newRect  = display.newRect,
                newText  = display.newText,
                fps      = display.fps,
                oriX     = display.screenOriginX,
                oriY     = display.screenOriginY,
                ctrX     = display.contentCenterX,
                ctrY     = display.contentCenterY,
                cntW     = display.contentWidth,
                cntH     = display.contentHeight,
                rep      = string.rep,
                format   = string.format,
                upper    = string.upper,
                gsub     = string.gsub,
                len      = string.len,
                sub      = string.sub,
                info     = system.getInfo,
                alert    = native.showAlert,
                cancel   = native.cancelAlert,
                showPopUp= native.showPopup,
                close    = io.close,
                open     = io.open,
                delete   = os.remove,
                time     = os.time,
                date     = os.date,
                random   = math.random,
                round    = math.round,
                floor    = math.floor,
                ceil     = math.ceil,
                abs      = math.abs,
                min      = math.min,
                max      = math.max,
                isTall   = display.pixelHeight > 960 and display.contentHeight - 480 or 0,
                path     = system.pathForFile("blackBox.txt",
                          system.DocumentsDirectory)
                }
  local var, old = {}, {}
        var.left, var.middle, var.right, var.start = {0,100}, {_api.ctrX-50,_api.ctrX+50}, {(_api.cntW-100),_api.cntW}, ""
        var.long, var.medium, var.short = 0.75, 0.50, 0.25
        var.swipe = 0
        var.menu = 1
        var.alert = _api.alert()
        var.touches = {}
        var.count = 0
        var.text = {"","","","",""}
        var.gps, var.gpsShowing = 0, 0
        var.display, var.topPage, var.currPage = false, true, 1
        var.scale = display.contentWidth > 600 and 2 or 1
        var.displayLength = _api.round((_api.cntH - _api.oriY) - 50)
        var.lineCount = _api.round((var.displayLength/var.scale)/16)-(system.orientation == "portrait" and 1 or 2)
        var.scrShot = false
        var.attach = {{ baseDir = system.DocumentsDirectory,
                      filename = "blackBox.txt",
                          type = "text" }}
  local btns = {}
  local infoBar, info, background, appText, pageNumber, ad
  local data = {}
  oldPrint = print
    data.btnNames = { {"@"},
                      {"X", "Menu", "ScrCap", "PgUp", "", "PgDn"},
                      {"X", "Back", "File", "View", "PgUp", "", "PgDn"},
                      {"X", "Back", "Save", "Delete", "Send", "ClrMem"},
                      {"X", "Back", "ScrShot", "Status"},
                      {"X", "Back", "On", "Mem", "Touch", "Accel", "Gyro", "GPS"} }
    data.infoBar  = { On = 0, Curr = 0, Mem = 0, Touch = 0, Accel = 0, Gyro = 0, GPS = 0 }
    data.appFile = {}
----------------------------------------------------------------------------------
-- GROUPS
  local blackBoxGroup = _api.newGroup()
  local infoBarGroup= _api.newGroup()
  local btnGroup    = _api.newGroup()
  local menuGroup   = {}
  for a = 1, #data.btnNames do
    menuGroup[a] = _api.newGroup()
    btnGroup:insert(menuGroup[a])
  end
  blackBoxGroup:insert(btnGroup)
  blackBoxGroup:insert(infoBarGroup)
----------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------
  local function chkFileNames()
    old.newImageSheet = graphics.newImageSheet
    old.newImage = display.newImage
    old.newImageRect = display.newImageRect
    old.loadSound = audio.loadSound
    old.loadStream = audio.loadStream
    local function _newImageSheet(...)
      local iSheet = old.newImageSheet(...)
      local args = {...}
      local fName = type(args[1]) == "string" and args[1] or nil
      assert(iSheet, tostring(args[1]).." is incorrect filename")
      return iSheet
    end
    local function _newImage(...)
      local iSheet = old.newImage(...)
      local args = {...}
      local fName = type(args[1]) == "string" and args[1] or args[2]
      assert(iSheet, tostring(fName).." is incorrect filename")
      return iSheet
    end
    local function _newImageRect(...)
      local iSheet = old.newImageRect(...)
      local args = {...}
      local fName = type(args[1]) == "string" and args[1] or args[2]
      assert(iSheet, tostring(fName).." is incorrect filename")
      return iSheet
    end
    local function _loadSound(...)
      local iSound = old.loadSound(...)
      local args = {...}
      local fName = type(args[1]) == "string" and args[1] or nil
      assert(iSound, tostring(fName).." is incorrect filename")
      return iSound
    end
    local function _loadStream(...)
      local iSound = old.loadStream(...)
      local args = {...}
      local fName = type(args[1]) == "string" and args[1] or nil
      assert(iSound, tostring(fName).." is incorrect filename")
      return iSound
    end
    graphics.newImageSheet = _newImageSheet
    display.newImage = _newImage
    display.newImageRect = _newImageRect
    audio.loadSound = _loadSound
    audio.loadStream = _loadStream
  end
  local function pushScreen(pushAmount)
    if paramsVar.screen == "push" then
      display.currentStage.y = display.currentStage.y + pushAmount
      appText.y = appText.y - pushAmount
      infoBarGroup.y = infoBarGroup.y - pushAmount
    end
  end
  local function saveFile()
    local fh, v = _api.open(_api.path, "a")
    fh:write( "\n----------------------------------------\n")
    fh:write( "       ".._api.date("%c").."\n")
    fh:write( "----------------------------------------\n")
    fh:write( "Model:              ".._api.info("model").."\n")
    fh:write( "Platform Name:      ".._api.info("platformName").."\n")
    fh:write( "Platform Version:   ".._api.info("platformVersion").."\n")
    fh:write( "Architecture:       ".._api.info("architectureInfo").."\n")
    fh:write( "Max Texture Size:   ".._api.info("maxTextureSize").."\n")
    fh:write( "\n----------- PRINT STATEMENTS -----------\n")
    for _,v in ipairs(data.appFile) do
      fh:write( v.."\n" )
    end
    _api.close(fh)
    fh, v = nil, nil
  end
  local function printMem()
    collectgarbage("collect")
    local usedMem = collectgarbage("count")
    local texMem = (_api.info("textureMemoryUsed")/1048576)
    print("\n*** MEMORY USAGE ***")
    print(_api.date("%c"))
    print("FPS:".._api.fps..", System:".._api.format("%.00f", usedMem).."KB, Texture:".._api.format("%.02f", texMem).."MB\n")
  end
  local function updateLogDisplay()
    local a, b
    appText.text = ""
    local tempText, text = "", ""
    local top     = #data.appFile
    local topPage = _api.ceil(top/var.lineCount)
    local start   = var.topPage == true and top or _api.min(top, (var.currPage*var.lineCount))
    local finish  = _api.max(1,start - var.lineCount)
    if top == start then
      var.currPage = top > var.lineCount and topPage or var.currPage
    end
    pageNumber.text = (_api.len(var.currPage) < 4) and ( top == start and "TOP" or var.currPage ) or ".".._api.sub(var.currPage,-3)
      for a = start, finish, -1 do
        local tempText = data.appFile[a]
        if _api.len(tempText) > 40 then tempText = _api.sub( tempText,1,47).." ..." end
        text = text.."\n"..tempText
      end
      appText.text = text
      a, b, start, finish, top, text, tempText = nil, nil, nil, nil, nil, nil, nil
  end
  local function invertColor(arg)
    local color, newColor = arg, {}
    for a = 1, 3 do
      newColor[a] = color[a] == 255 and 0 or 255
    end
    return newColor
  end
-- BACKGROUND ALPHA
  local function adjustAlpha()
    var.display = true
    var.menu = 2
    appText.isVisible = true
    appText:toFront()
    background:setFillColor(0, 0, 0, (_api.min(_api.max(0,paramsVar.bgAlpha or 100),255)))
    updateLogDisplay()
  end
----------------------------------------------------------------------------------
-- UPDATE STATUS BAR TEXT
  local function fitText()
    info.xScale = info.width > 240 and (infoBar.width-20)/info.width or 1
  end
  local function updateBarText(e)
    local fnct = {}
      fnct.Mem = function()
        collectgarbage("collect")
        local usedMem = collectgarbage("count")
        local texMem = (_api.info("textureMemoryUsed")/1048576)
        info.text = "FPS:".._api.fps..", System:".._api.format("%.00f", usedMem).."KB, Texture:".._api.format("%.02f", texMem).."MB"
        fitText()
      end
      fnct.Touch = function()
        local function track()
          local ct = 0
          var.text = { "", "", "", "", "" }
          for k,v in pairs(var.touches) do
            ct = ct + 1
            var.text[ct] = ct..":("..e.x..","..e.y..")   "
          end
          info.text = ct > 0 and var.text[1]..var.text[2]..var.text[3]..var.text[4]..var.text[5] or "No touch detected."
          if #info.text > 40 then fitText() end
        end
        if e.phase == "began" then
          var.touches[e.id] = e
        end
        if e.phase == "ended" then
          var.touches[e.id] = nil
        end
        track()
      end
      fnct.Accel = function()
        info.text = system.hasEventSource("accelerometer") == true and "ACCEL. - x:(".._api.format("%.02f",e.xGravity)..")  y:(".._api.format("%.02f",e.yGravity)..")  z:(".._api.format("%.02f",e.zGravity)..")" or "Accelerometer not found."
        fitText()
      end
      fnct.Gyro = function()
        info.text = system.hasEventSource("gyroscope") == true and "GYRO - x:(".._api.format("%.02f",e.xRotation)..")  y:(".._api.format("%.02f",e.yRotation)..")  z:(".._api.format("%.02f",e.zRotation)..")" or "Gyroscope not found."
        fitText()
      end
      fnct.GPS = function()
        var.gpsShowing = 1
        var.gps = (var.gps + 1)%2
        if system.hasEventSource("location") == true then
          info.text = var.gps == 1 and "GPS - latitude:("..(_api.format("%.02f",e.latitude) or "0")..") longitude:("..(_api.format("%.02f",e.longitude)or "0")..")" or "GPS - alt:(".._api.format("%.02f",e.altitude)..")  dir:("..(e.direction or "0")..")   spd:("..(e.speed or "0")..")"
        else
          info.text = "GPS not found."
        end
        fitText()
      end
      if data.btnNames[6][data.infoBar.Curr] ~= nil then
        fnct[data.btnNames[6][data.infoBar.Curr]]()
      end
  end
----------------------------------------------------------------------------------
-- CHECK FOR SWIPE
  local function checkForSwipe(e)
    local swipeArea = var[(paramsVar.swipeArea or "left")]
    local phase = e.phase
    local fnct = {}
    fnct.began = function()
      display.getCurrentStage():setFocus(target)
      var.start = e.yStart
    end
    fnct.moved = function()
      if e.x > (swipeArea[1]*var.scale) and e.x < (swipeArea[2]*var.scale) and var.swipe == 0 then
        if _api.abs( e.y - var.start ) > (_api.cntH*(var[paramsVar.swipeDistance])) then
          background:setFillColor(0, 255, 0, 50)
        end
      end
    end
    fnct.ended = function()
      if e.x > (swipeArea[1]*var.scale) and e.x < (swipeArea[2]*var.scale) and var.swipe == 0 then
        if _api.abs( e.y - var.start ) > (_api.cntH*(var[paramsVar.swipeDistance])) then
          adjustAlpha()
          display.getCurrentStage():setFocus(nil)
          menuGroup[2].isVisible = true
          pushScreen(30)
          var.swipe = 1
        end
      end
    end
    fnct.cancelled = function()
      adjustAlpha()
      display.getCurrentStage():setFocus(nil)
      menuGroup[2].isVisible = true
    end
    fnct[phase]()
  end
----------------------------------------------------------------------------------
-- UPDATE INFO BAR
  local function removeListener()
    local fnct = {}
    fnct.Mem = function()
      Runtime:removeEventListener("enterFrame", updateBarText)
    end
    fnct.Touch = function()
      Runtime:removeEventListener("touch", updateBarText)
      var.touches = {}
    end
    fnct.Accel = function()
      Runtime:removeEventListener("accelerometer", updateBarText)
    end
    fnct.Gyro = function()
      Runtime:removeEventListener("gyroscope", updateBarText)
    end
    fnct.GPS = function()
      Runtime:removeEventListener("location", updateBarText)
    end
    fnct[data.btnNames[6][data.infoBar.Curr]]()
  end
  local function updateBar(e)
    local e = e
    removeListener()
    data.infoBar.Curr = ((data.infoBar.Curr + 2)%5)+4
    while data.infoBar[data.btnNames[6][data.infoBar.Curr]] == 0 do
      data.infoBar.Curr = ((data.infoBar.Curr + 2)%5)+4
    end
    local fnct = {}
    fnct.Mem = function()
      Runtime:addEventListener("enterFrame", updateBarText)
    end
    fnct.Touch = function()
      Runtime:addEventListener("touch", updateBarText)
      info.text = "No touch detected."
    end
    fnct.Accel = function()
      if _api.info("environment") == "device" then
        Runtime:addEventListener("accelerometer", updateBarText)
      else
        info.text = "Accelerometer not supported in simulator."
        fitText()
      end
    end
    fnct.Gyro = function()
      if _api.info("environment") == "device" then
        Runtime:addEventListener("gyroscope", updateBarText)
      else
        info.text = "Gyroscope not supported in simulator."
        fitText()
      end
    end
    fnct.GPS = function()
      Runtime:addEventListener("location", updateBarText)
    end
    if var.gps == 1 and var.gpsShowing == 1 then
      data.infoBar.Curr = 8
    end
    fnct[data.btnNames[6][data.infoBar.Curr]]()
  end
----------------------------------------------------------------------------------
-- BUTTON PRESSED
  local function btnReleased(e, e2)
    local id = ( type(e) == "string" and e or e.target.id)
    id = id == "@" and "Activate" or id
    ----------------------------------------------------------------------
    local changeMenu = function( a, b )
      menuGroup[a].isVisible = false
      if b ~= nil then
        menuGroup[b].isVisible = true
      end
    end
    ---------------------------------------------------------------------
    local toggleSwitch = function()
      data.infoBar[id] = (data.infoBar[id] + 1)%2
      if paramsVar.method ~= "code" then
        e.target:setFillColor( data.infoBar[id] == 0 and 255 or 0, data.infoBar[id] == 0 and 0 or 255, 0, 255)
        if data.infoBar.Mem == 0 and data.infoBar.Touch == 0 and data.infoBar.Accel == 0 and
          data.infoBar.Gyro == 0 and data.infoBar.GPS == 0 and data.infoBar.On == 1 then
          data.infoBar.On = 0
          removeListener()
          btns[6][3]:setFillColor(255, 0, 0, 255)
          data.infoBar.Curr = 0
          infoBar.isVisible = false
          infoBar:removeEventListener("touch", updateBar)
          info.text = ""
       end
     end
    end
    ---------------------------------------------------------------------
    local fnct = {}
    fnct.Activate = function()
      adjustAlpha()
      var.menu = 2
      changeMenu( 1, 2)
      pushScreen(30)
    end
    fnct.X = function()
      background:setFillColor(0, 0, 0, 0)
      var.display = false
      var.swipe = 0
      appText.isVisible = false
      display.remove(var.img)
      var.scrShot = false
      changeMenu( var.menu, (paramsVar.method == "button") and 1 or nil )
      pushScreen(-30)
      menuGroup[2]:insert(pageNumber)
      pageNumber.x, pageNumber.y = btns[2][5].x, btns[2][5].y
    end
    fnct.Menu = function()
      var.menu = 3
      changeMenu( 2, 3 )
      menuGroup[3]:insert(pageNumber)
      pageNumber.x, pageNumber.y = btns[3][6].x, btns[3][6].y
      pageNumber:toFront()
    end
    fnct.ScrCap = function()
      blackBoxGroup.isVisible = false
      local background1 = _api.newRect(_api.oriX, _api.oriY, -2*_api.oriX+_api.cntW, -2*_api.oriY+_api.cntH)
      background1:setFillColor(0, 0, 0, 255)
      background1:toBack()
      display.save( display.currentStage, "blackBoxScreenShot.jpeg" )
      var.alert = native.showAlert("Screen Capture",  "Screen Shot Taken", {"OK"}, function() native.cancelAlert(var.alert) display.remove( background1 ) end)
      print("Screen Shot Saved")
      var.attach[#var.attach+1] = { baseDir = system.DocumentsDirectory,
                                   filename = "blackBoxScreenShot.jpeg",
                                       type = "image" }
      blackBoxGroup.isVisible = true
    end
    fnct.PgUp = function()
      var.currPage = _api.min( (_api.ceil(#data.appFile/var.lineCount)), var.currPage + 1)
      var.topPage = var.currPage == _api.ceil(#data.appFile/var.lineCount) and true or false
      updateLogDisplay()
    end
    fnct.PgDn = function()
      var.currPage = _api.max( 1,  var.currPage - 1 )
      var.topPage = var.currPage == _api.ceil(#data.appFile/var.lineCount) and true or false
      updateLogDisplay()
    end
    fnct.File = function()
      var.menu = 4
      changeMenu( 3, 4 )
    end
    fnct.Save = function()
      local function yes(event)
        if event == true or event.index == 2 then
          saveFile()
        end
        if var.alert then
          _api.cancel(var.alert)
        end
      end
      if paramsVar.method ~= "code" then
        if e2 == true then
          yes(true)
        else
          var.alert = _api.alert("Save",  "Save blackBox file.", {"No", "Yes"}, yes)
        end
      else
        yes(true)
      end
    end
    fnct.Delete = function()
      local function yes(event)
        if event == true or event.index == 2 then
          _api.delete( _api.path )
          _api.delete( system.pathForFile("blackBoxScreenShot.jpeg",system.DocumentsDirectory) )
          data.appFile = {}
          updateLogDisplay()
        end
        if var.alert then
          _api.cancel(var.alert)
        end
      end
      if paramsVar.method ~= "code" then
        if e2 == true then
          yes(true)
        else
          var.alert = _api.alert("Delete",  "Warning. This will delete the blackBox file and any screen shots.", {"No", "Yes"}, yes)
        end
      else
        yes(true)
      end
    end
    fnct.Send = function()
      if _api.info("environment") == "device" then
        local function yes(event)
          if event == true or event.index == 2 then
            print("Sending eMail.")
            saveFile()
            oldPrint("sending...")
            local options = { to = paramsVar.eMail,
                         subject = "blackBox.txt",
                            body = "betaTest ".._api.info("appName"),
                      attachment = var.attach }
                      _api.showPopUp( "mail", options )
                         options = nil
            if paramsVar.resetOnSend == true then btnReleased("Delete",true) end
          end
          if var.alert then
            _api.cancel(var.alert)
          end
        end
        if paramsVar.method ~= "code" then
          if e2 == true then
            yes(true)
          else
            var.alert = _api.alert("eMail",  "eMail blackBox", {"No", "Yes"}, yes)
          end
        else
          yes(true)
        end
      else
        var.alert = native.showAlert("eMail",  "eMail not supported in simulator", {"Ok"}, function()
            _api.cancel(var.alert)
        end)
        print( "** Can't send eMail from simulator. **" )
      end
    end
    fnct.ClrMem = function()
      local function yes(event)
        if event == true or event.index == 2 then
          print("Memory Cleared.")
          saveFile()
          data.appFile = {}
          updateLogDisplay()
        end
        if var.alert then
          _api.cancel(var.alert)
        end
      end
      if paramsVar.method ~= "code" then
        var.alert = _api.alert("Clear Memory",  "This will clear extra memory caused from blackBox.\nYou will no longer be able to view prior info from device.\nProceed?", {"No", "Yes"}, yes)
      else
        yes(true)
      end
    end
    fnct.On = function()
      if ( data.infoBar.Mem == 1 or data.infoBar.Touch == 1 or data.infoBar.Accel == 1 or
           data.infoBar.Gyro == 1 or data.infoBar.GPS == 1) then
           toggleSwitch()
        if data.infoBar.On == 1 then
          data.infoBar.Curr = ( data.infoBar.Mem == 1 and 4 or
                                data.infoBar.Touch == 1 and 5 or
                                data.infoBar.Accel == 1 and 6 or
                                data.infoBar.Gyro == 1 and 7 or
                                data.infoBar.GPS == 1 and 8 or 0)
          infoBar.isVisible = true
          infoBar:addEventListener("tap", updateBar)
          updateBar()
        else
          data.infoBar.Curr = 0
          infoBar.isVisible = false
          infoBar:removeEventListener("tap", updateBar)
          info.text = ""
        end
      end
    end
    fnct.Mem = function()
      toggleSwitch()
    end
    fnct.Touch = function()
      toggleSwitch()
    end
    fnct.Accel = function()
      toggleSwitch()
    end
    fnct.Gyro = function()
      toggleSwitch()
    end
    fnct.GPS = function()
      toggleSwitch()
    end
    fnct.View = function()
      var.menu = 5
      changeMenu( 3, 5 )
    end
    fnct.ScrShot = function()
      if var.scrShot == false then
        pcall( function()
          var.img = display.newImageRect( blackBoxGroup, "blackBoxScreenShot.jpeg", system.DocumentsDirectory, _api.cntW *0.8, _api.cntH*0.8 )
          var.img.x, var.img.y = _api.ctrX, _api.ctrY
          var.img:setStrokeColor(paramsVar.mColor[1], paramsVar.mColor[2], paramsVar.mColor[3], 255)
          var.img.strokeWidth = 2
          var.img:toFront()
          var.scrShot = true
          end)
      end
    end
    fnct.blackBox = function()
      -- to be added. will reload entire blackBox file if clrmem button was pressed
    end
    fnct.Status = function()
      display.remove(var.img)
      var.scrShot = false
      var.menu = 6
      changeMenu( 5, 6 )
    end
    fnct.Back = function()
      if menuGroup[3].isVisible == true then
        var.menu = 2
        changeMenu( 3, 2 )
        menuGroup[2]:insert(pageNumber)
        pageNumber.x, pageNumber.y = btns[2][5].x, btns[2][5].y
      elseif menuGroup[4].isVisible == true then
        var.menu = 3
        changeMenu( 4, 3 )
      elseif menuGroup[5].isVisible == true then
        var.menu = 3
        display.remove(var.img)
        var.scrShot = false
        changeMenu( 5, 3 )
      else
        var.menu = 5
        changeMenu( 6, 5 )
      end
    end
    fnct[id]()
    --return false
  end
----------------------------------------------------------------------------------
-- SETUP ACTIVATION METHODS
  local function setupActivationMethods()
    local function checkShake(e)
      if e.isShake == true and var.swipe == 0 then
        adjustAlpha()
        menuGroup[2].isVisible = true
        pushScreen(30)
        var.swipe = 1
      end
    end
    local function ckGesture(e)
      if e.type == "match" and var.swipe == 0 then
        background:setFillColor(0, 255, 0, 50)
        timer.performWithDelay(300, function()
          var.swipe = 1
          adjustAlpha()
          menuGroup[2].isVisible = true
          pushScreen(30)
          end)
      end
    end
    local fnct, a = {}
        fnct.code = function()
          blackBox.showLog = function()
            adjustAlpha()
            menuGroup[2].isVisible = true
            pushScreen(30)
          end
          blackBox.send = function()
            btnReleased("Send")
          end
          blackBox.save = function()
            btnReleased("Save")
          end
          blackBox.delete = function()
            btnReleased("Delete")
          end
          blackBox.clearMemory = function()
            btnReleased("ClrMem")
          end
          blackBox.showStatusBar = function( ... )
            for _,v in ipairs(arg) do
              v = _api.gsub(v,"^%l", _api.upper)
              if data.infoBar[v] ~= nil then
                data.infoBar[v] = 1
              end
            end
            btnReleased("On")
          end
          blackBox.screenCapture = function()
            btnReleased("ScrCap")
          end
          blackBox.getFile = function()
            return data.appFile
          end
        end
        fnct.shake = function()
            Runtime:addEventListener("accelerometer", checkShake)
        end
        fnct.swipe = function()
            background:addEventListener("touch", checkForSwipe)
        end
        fnct.button = function()
          menuGroup[1].isVisible = true
        end
        fnct.gesture = function()
          gesture.newMotion( paramsVar.gesture, paramsVar.gestureRotation )
          gesture.start()
          Runtime:addEventListener("gesture", ckGesture)
        end
        fnct[paramsVar.method]()
    end
----------------------------------------------------------------------------------
-- BUILD MENUS
  local function buildButtons()
    for a = 1, #data.btnNames do
      btns[a] = {}
      for b = 1, #data.btnNames[a] do
        btns[a][b] = widget.newButton({ id = data.btnNames[a][b],
               top = paramsVar.screen == "push" and
                (a > 1 and -30+_api.oriY or _api.oriY + paramsVar.btnY) or
                (a == 1 and _api.oriY + paramsVar.btnY or _api.oriY ),
              left = a > 1 and menuGroup[a].width or paramsVar.btnX,
             label = data.btnNames[a][b],
        labelColor = { default = (data.btnNames[a][b] == "X" or data.btnNames[a][b] == "@") and
                                 { 0, 100, 0, 255} or
                                 invertColor(paramsVar.mColor),
                       over    = paramsVar.mColor},
             width = ( a==1 and 24 or ( (a>1 and b == 1) and 24 or (a==6 and 41 or 48) )* var.scale),
            height = 30*var.scale,
         isEnabled = ((data.btnNames[a][b] == "" and 0 or 1) == 1),
            emboss = false,
              font = native.systemFontBold,
          fontSize = (a == 1 and 16 or 10)*var.scale,
         onRelease = btnReleased,
          })
        btns[a][b]._label.yScale = a == 1 and 1 or 1.7
        local tc = (data.btnNames[a][b] == "@" or data.btnNames[a][b] == "X") and 200 or paramsVar.menuColor == "light" and 250 or 50
        btns[a][b]:setFillColor( (a == 6 and b > 2 and 255 or tc), (a == 6 and b > 2 and 0 or tc), (a == 6 and b > 2 and 0 or tc), 255 )
        menuGroup[a]:insert(btns[a][b])
      end
      menuGroup[a].x = _api.oriX
      menuGroup[a].isVisible = false
    end
    btns[2][5]:setReferencePoint(display.CenterReferencePoint)
    pageNumber = display.newText( menuGroup[2], "TOP", btns[2][5].x, btns[2][5].y, native.systemFontBold, 14*var.scale )
    pageNumber.x, pageNumber.y = btns[2][5].x, btns[2][5].y
    pageNumber:setTextColor( 255, 0, 0, 255)
  end
----------------------------------------------------------------------------------
-- BUILD INFOBARS
  local function buildInfoBar()
    infoBar = _api.newRect( infoBarGroup, _api.oriX + 0, 0, (2*_api.oriX) + _api.cntW, 24)
    infoBar:setFillColor(100, 30, 30, 200)
    infoBar.y = ((_api.cntH - 12)-_api.oriY)
    info = _api.newText( infoBarGroup, "", 0, infoBar.y-10, nil, 16*var.scale)
    info.x = _api.ctrX
    infoBar.isVisible = false
  end
----------------------------------------------------------------------------------
-- SYSTEM FUNCTIONS
  local function moveOnTop()
    blackBoxGroup:toFront()
  end
  blackBox.clean = function()
    Runtime:removeEventListener("system", onSystemEvent)
    Runtime:removeEventListener("memoryWarning", onSystemEvent)
    Runtime:removeEventListener( "unhandledError", errorHandler )
    Runtime:removeEventListener("enterFrame", moveOnTop)
    if var.pmi then timer.cancel(var.pmi) end
    local fnct = {}
      fnct.On = function()
        infoBar:removeEventListener("touch", updateBar)
      end
      fnct.Mem = function()
        Runtime:removeEventListener("enterFrame", updateBarText)
      end
      fnct.Touch = function()
        Runtime:removeEventListener("touch", updateBarText)
      end
      fnct.Accel = function()
        Runtime:removeEventListener("accelerometer", updateBarText)
      end
      fnct.Gyro = function()
        Runtime:removeEventListener("gyroscope", updateBarText)
      end
      fnct.GPS = function()
        Runtime:removeEventListener("location", updateBarText)
      end
      fnct.Button = function()
      end
      fnct.Code = function()
      end
      fnct.Shake = function()

      end
      fnct.Swipe = function()
        background:removeEventListener("touch", checkForSwipe)
      end
      fnct.Gesture = function()
        Runtime:removeEventListener("gesture", ckGesture)
      end
      if data.infoBar.On == 1 then
        for a = 3, #data.btnNames do
          if data.infoBar[data.btnNames[a]] == 1 then
            fnct[data.btnNames[6][a]]()
          end
        end
        fnct.On()
      end
  end
  local function onSystemEvent(e)
    printMem()
    print( e.name.." event "..(e.type or ""))
    if e.name == "unhandledError" then
      print( e.errorMessage )
      print( e.stackTrace )
      if paramsVar.sendOnError == true then
        btnReleased("Send")
      else
        btnReleased("Save",true)
      end
    end
    if e.name == "memoryWarning" then
      if paramsVar.sendOnError == true then
        btnReleased("Send")
      else
        btnReleased("Save",true)
      end
    end
    if e.type == "applicationExit" then
      btnReleased("Save",true)
    end
    if e.type == "applicationSuspend" then
      btnReleased("Save",true)
    end
    if e.type == "applicationResume" then
      if paramsVar.sendOnResume == true then
        btnReleased("Send")
      end
    end
  end
----------------------------------------------------------------------------------
-- INIT blackBox
  function blackBox.init()
    local b, c, a = 0, 0
    local actMethods = { "button", "swipe", "shake", "gesture", "code" }
    for a = 1, #actMethods do
      if paramsVar.activation == actMethods[a] then
        b = 1
      end
    end
      paramsVar.method = b == 1 and paramsVar.activation or "button"
      if paramsVar.method == "gesture" and gesture == "" then
        paramsVar.method = "button"
        print("Gesture module not found")
      end
      paramsVar.printMemInterval = 120000
      paramsVar.btnX = paramsVar.btnX or 0
      paramsVar.btnY = paramsVar.btnY or 0
      paramsVar.gesture = paramsVar.gesture or ""
      paramsVar.gestureRotation = paramsVar.gestureRotation or 0
      paramsVar.menuColor = paramsVar.menuColor or "light"
      paramsVar.mColor = { paramsVar.menuColor == "light" and 255 or 100,
                           paramsVar.menuColor == "light" and 255 or 100,
                           paramsVar.menuColor == "light" and 255 or 100,
                           255 }
      paramsVar.textColor = paramsVar.textColor or {}
      paramsVar.displayCount = paramsVar.displayCount or nil
      if paramsVar.displayCount ~= nil then
        var.lineCount = _api.min((_api.max(3,paramsVar.displayCount)-1),var.lineCount)
      end
      paramsVar.blackBoxMode = paramsVar.blackBoxMode or false
      paramsVar.sendOnResume = paramsVar.sendOnResume or false
      paramsVar.resetOnSend = paramsVar.resetOnSend or false
      paramsVar.sendOnEnd = paramsVar.sendOnEnd or true
      paramsVar.sendOnError = paramsVar.sendOnError or true
      paramsVar.checkFileNames = paramsVar.checkFileNames or false
      invertColor(paramsVar.mColor)
      paramsVar.swipeDistance = paramsVar.swipeDistance or "long"
      if paramsVar.blackBoxMode == true then
        paramsVar.method = "code"
        paramsVar.printMemInterval = nil
        paramsVar.sendOnResume = false
        paramsVar.sendOnError = true
        paramsVar.resetOnSend = true
        paramsVar.endDate = _api.date("*t")
        paramsVar.endDate.day = paramsVar.endDate.day + 1
      end
    if _api.time(_api.date("*t")) <= _api.time(paramsVar.endDate) then
      method, a, b = nil, nil, nil
      background = _api.newRect(_api.oriX, _api.oriY, -2*_api.oriX+_api.cntW, -2*_api.oriY+_api.cntH)
      background:setFillColor(0, 0, 0, 0)
      var.displayLength = var.displayLength+(var.displayLength%4)
      appText = display.newText( blackBoxGroup, "", _api.oriX, _api.oriY+20, _api.cntW-_api.oriX, var.displayLength, native.systemFontBold, 12*var.scale )
      appText:setTextColor( (paramsVar.textColor[1] or 255),
                            (paramsVar.textColor[2] or 255),
                            (paramsVar.textColor[3] or 255),
                             255)
      appText.isVisible = false
      blackBoxGroup:insert(1, background)
      if paramsVar.checkFileNames == true then
        chkFileNames()
      end
      --------------------------------------------------------------
      --Runtime:addEventListener("orientation", onOrientationChange)
      -- to be added at a later time
      --------------------------------------------------------------
      Runtime:addEventListener("system", onSystemEvent)
      Runtime:addEventListener("memoryWarning", onSystemEvent)
      Runtime:addEventListener( "unhandledError", onSystemEvent )
      Runtime:addEventListener("enterFrame", moveOnTop)
      if paramsVar.printMemInterval then
        var.pmi = timer.performWithDelay( paramsVar.printMemInterval, printMem )
      end
      buildButtons()
      buildInfoBar()
      setupActivationMethods()
      blackBoxGroup:setReferencePoint(display.TopLeftReferencePoint)
      print("__________ NEW RUN __________")
      print = function(...)
        oldPrint(unpack(arg))

        local str, v = ""
        for _,v in ipairs(arg) do
          str = str .. "    ".. tostring(v)
        end
        data.appFile[#data.appFile+1] = str
        str, v, arg = nil, nil, nil
        if paramsVar.refresh == true and var.display == true then
          updateLogDisplay()
        end
      end
    else
      print = oldPrint
      if paramsVar.sendOnEnd == true then
        local fh = _api.open( _api.path, "r" )
        if fh then
          btnReleased("Send",true)
          btnReleased("Delete",true)
          _api.close(fh)
          fh = nil
        end
      end
      paramsVar, _api, var = nil, nil, nil
    end
  end
return blackBox

-- NOTES --





