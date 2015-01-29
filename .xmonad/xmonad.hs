--
-- Joey Pereira (xLegoz)
-- xmonad configuration
-- xmonad.hs
--

--
-- Import stuff
import XMonad
import qualified XMonad.StackSet as W 
import XMonad.Util.EZConfig
import System.IO
import Graphics.X11.ExtraTypes.XF86
import Data.Ratio ((%))
-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
-- utils
import XMonad.Util.Scratchpad
import XMonad.Util.Run
import XMonad.Prompt
-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.ManageHook
import Data.List 
-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Reflect
import XMonad.Layout.IM
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Grid 

main = do
  -- init xmobar
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
  -- init nitrogen (background image)
  nitroproc <- spawnPipe "nitrogen --restore"
  xmonad $ defaultConfig {
      workspaces = myWorkspaces
    , manageHook = myManageHook
    , layoutHook = myLayoutHook
    , terminal    = myTerminal
    , modMask     = myModMask
    , borderWidth = myBorderWidth
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor = myNormalBorderColor
    , focusFollowsMouse = True
    , logHook = dynamicLogWithPP xmobarPP
              { ppOutput = hPutStrLn xmproc
              , ppTitle = xmobarColor "green" "" . shorten 50
              }
    } 
    `additionalKeysP`
	    [ ("M-d", scratchpadSpawnActionCustom "gnome-terminal -e 'vim'")
	    , ("M-f", runOrRaise "firefox-nightly" (className =? "Firefox"))]
    `additionalKeys`
      [ ((0, xF86XK_AudioLowerVolume ), spawn "amixer set Master 3-")
      , ((0, xF86XK_AudioRaiseVolume ), spawn "amixer set Master 3+")
      , ((0, xF86XK_AudioMute ), spawn "amixer set Master toggle")
      --, ((0, xF86XK_KbdBrightnessDown ), spawn "asus-kbd-backlight down")
      --, ((0, xF86XK_KbdBrightnessUp ), spawn "asus-kbd-backlight up")
      , ((0, xK_Print), spawn "scrot")
      
      -- launching programs
      , ((0, xF86XK_Mail), runOrRaise "thunderbird" (className =? "Thunderbird"))
      , ((0, xF86XK_Messenger), runOrRaise "pidgin" (className =? "Pidgin"))
      , ((0, 0x1008ff18), runOrRaise "firefox-aurora" (className =? "Firefox"))
      ]
      
-- Hooks --

-- automatically switch windows to workspaces
myManageHook = composeAll
   [ isFullscreen                  --> doFullFloat
    , title =? "Open File"      --> doCenterFloat
    , className =? "Xmessage"       --> doCenterFloat
    , className =? "Xfce4-notifyd"  --> doIgnore
    , className =? "stalonetray"    --> doIgnore
    , className =? "Thunderbird"    --> doShift "2:web"
    , className =? "Pidgin"         --> doShift "4:chat"
    , className =? "Skype"          --> doShift "4:chat"
    , className =? "MPlayer"        --> doShift "8:vid"
    , className =? "mplayer2"       --> doShift "8:vid"
    , className =? "mpv"            --> doShift "8:vid"
    , className =? "Crossover"      --> doShift "7:games"
    , className =? "Steam"          --> doShift "7:games"
    , className =? "Wine"           --> doShift "7:games"
    , className =? "rdesktop"       --> doShift "6:vm"
    , className =? "Texmaker"       --> doShift "5:doc"
    , className =? "SeamlessRDP"    --> doShift "5:doc"
    , className =? "MPlayer"       --> (ask >>= doF . W.sink)       
    , className =? "Vlc" --> doFloat
    , className =? "Gimp" --> doFloat
    , className =? "XCalc" --> doFloat
    , className =? "Firefox"        --> doShift "2:web"
    , manageDocks
    , scratchpadManageHook (W.RationalRect 0.125 0.25 0.75 0.5)
    ]

--logHook
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h}


-- Looks --

-- bar
customPP :: PP
customPP = defaultPP {
                       ppHidden = xmobarColor "#00FF00" ""
                     , ppCurrent = xmobarColor "#FF0000" "" . wrap "[" "]"
                     , ppUrgent = xmobarColor "#FF0000" "" . wrap "*" "*"
                     , ppLayout = xmobarColor "#FF0000" ""
                     , ppTitle = xmobarColor "#00FF00" "" . shorten 80
                     , ppSep = "<fc=#0033FF> | </fc>"
                     }

-- some nice colors for prompt windows to match status bar
myXPConfig = defaultXPConfig
  { font = "-*-terminus-*-*-*-*-12-*-*-*-*-*-*-u"
  , fgColor = "#0096D1"
  , bgColor = "#000000"
  , bgHLight = "#000000"
  , fgHLight = "#FF0000"
  , position = Top
  , historySize = 512
  , showCompletionOnTab = True
  , historyFilter = deleteConsecutive
  }

-- layouthook
myLayoutHook = onWorkspace "4:chat" imLayout $ onWorkspace "6:vm" fullL $ onWorkspace "8:vid" fullL $ onWorkspace "7:games" standardLayouts $ standardLayouts
  where
    standardLayouts = avoidStruts $ (tiled ||| reflectTiled ||| Mirror tiled ||| Grid ||| Full)

    --layouts
    tiled = smartBorders (ResizableTall 1 (2/100) (1/2) [])
    reflectTiled = (reflectHoriz tiled)
    full = noBorders Full

    --im layout
    --show pidget tiled left, skype right
    imLayout = avoidStruts $ smartBorders $ withIM ratio pidginRoster $ reflectHoriz $ withIM skypeRatio skypeRoster (tiled ||| reflectTiled ||| Grid) where
      chatLayout = Grid
      ratio = (1 % 9)
      skypeRatio = (1 % 8)
      pidginRoster = And (ClassName "Pidgin") (Role "buddy_list")
      skypeRoster = (ClassName "Skype") `And`
                    (Not (Title "Options")) `And`
                      (Not (Role "Chats")) `And`
                        (Not (Role "CallWindowForm"))
    
    --weblayout
    webL = avoidStruts $ full ||| tiled ||| reflectHoriz tiled

    --virtuallayout
    fullL = avoidStruts $ full


-------------------
--personal settings
--terminal
myTerminal :: String
myTerminal    = "xfce4-terminal"

--keys/button bindings
--modmask
myModMask :: KeyMask
myModMask     = mod4Mask -- Win key or Super_L

--borders for windows
myBorderWidth :: Dimension
myBorderWidth = 2

myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor = "#333333"
myFocusedBorderColor = "#0C31E8"

--Workspaces
myWorkspaces :: [WorkspaceId]
myWorkspaces = [ "1:main", "2:web", "3:dev", "4:chat", "5:doc", "6:vm", "7:games", "8:vid"]
