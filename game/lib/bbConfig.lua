-- OPTIONS --
-- activation methods
--      activation               string                          ("button", "shake", "swipe", "code", "gesture" )
--      ** NOTE ** gesture requires the gesture class

-- for button activation
--      btnX                     button x location               ( number )
--      btnY                     button y location               ( number )

-- for swipe activation
--      swipeDistance            length of swipe                 ( "short", "medium", "long" )
--      swipeArea                area of screen to swipe         ( "left", "middle", "right" )

-- for shake activation

-- for gesture activation ** NOTE ** must have gesture module
--      gesture                  the gesture to detect           ( see gesture module for instructions )
--      gestureRotation          rotate the gesture detection    ( seee gesture module for instructions )

-- for code activation
--      list of usable functions
--      blackBox.send()          sends file
--      blackBox.save()          save log file
--      blackBox.delete()        deletes log file
--      blackBox.clearMemory()   clears memory used by blackBox
--      blackBox.showStatusBar() displays the status bar         ( "Mem", "Touch", "Accel", "Gyro", "GPS" )
--      blackBox.screenCapture() takes a screen shot
--      blackBox.getFile()       returns the log file

-- for use with all activations methods
--      menuColor                color of menu buttons           ( "light", "dark" )
--      textColor                color of print statements       ( { r, g, b, a } )
--      displayCount             number of prints per page       ( number )
--      bgAlpha                  alpha of print background       ( number )
--      screen                   how to deal with game screen    ( "push", "overlay" )
--      refresh                  auto refresh prints             ( true, false )
--      sendOnResume             send file on app resume         ( true, false )
--      resetOnSend              reset log file on send          ( true, false )
--      eMail                    eMail to send file to           ( eMail address )
--      endDate                  date to end blackBox            ( { year = , month = , day = } )
--      checkFileNames           checks image filenames          ( true, false )
--      if no end date given blackBox runs forever

-- future options
--      checkForUpdate
--      killApp
--




    bbConfig =
    {   activation     = "button",
        btnX           = 300,
        btnY           = -200,
        endDate        = { year = 2014, month = 1, day = 1},
        eMail          = "defossez.aurelien@tabemasu.com",
        sendOnResume   = false,
        resetOnSend    = false,
        refresh        = true,
        screen         = "overlay",
        menuColor      = "light",
        textColor      = { 255, 255, 255 },
        bgAlpha        = 150,
        checkFileNames = true,
    }
    return bbConfig
