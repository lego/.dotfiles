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
import XMonad.Actions.SpawnOn (spawnOn)
-- utils
import XMonad.Util.Scratchpad
import XMonad.Util.Run
import XMonad.Prompt
-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
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
  xmonad $ ewmh defaultConfig {
      workspaces = myWorkspaces
  --, startupHook = myStartupHook
    , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
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
      [ ("M-d", scratchpadSpawnActionCustom "xfce4-terminal -e 'vim'")
      , ("M-f", runOrRaise "chromium" (className =? "Chromium"))]
    `additionalKeys`
      [ ((0, xF86XK_AudioLowerVolume ), spawn "amixer -q sset Master 3%-")
      , ((0, xF86XK_AudioRaiseVolume ), spawn "amixer -q sset Master 3%+")
      , ((0, xF86XK_AudioMute ), spawn "amixer set Master toggle")
      , ((0, xF86XK_KbdBrightnessDown ), spawn "sudo asus-kbd-backlight down")
      , ((0, xF86XK_KbdBrightnessUp ), spawn "sudo asus-kbd-backlight up")
      , ((0, xF86XK_MonBrightnessDown ), spawn "xbacklight -dec 10")
      , ((0, xF86XK_MonBrightnessUp ), spawn "xbacklight -inc 10")
      , ((0, xK_Print), spawn "scrot")

      -- launching programs
      , ((0, 0x1008ff18), runOrRaise "chromium" (className =? "Chromium"))
      ]

-- Hooks --

-- automatically switch windows to workspaces
myManageHook = composeAll
   [ isFullscreen                  --> doFullFloat
    , className =? "Xmessage"       --> doCenterFloat
    , className =? "Xfce4-notifyd"  --> doIgnore
    , className =? "stalonetray"    --> doIgnore
    , className =? "MPlayer"       --> (ask >>= doF . W.sink)
    , className =? "Vlc" --> doFloat
    , className =? "Gimp" --> doFloat
    , title =? "Open File" --> doCenterFloat
    , title =? "Open" --> doCenterFloat
    , className =? "XCalc" --> doFloat
    , manageDocks
    , scratchpadManageHook (W.RationalRect 0.125 0.25 0.75 0.5)
    ]

-- startup hook --
--myStartupHook = do
--  spawnOn (myWorkspaces!!0) "chromium"
--  spawnOn (myWorkspaces!!1) "subl3"
--  spawnOn (myWorkspaces!!3) "xfce4-terminal"
--  spawnOn vim (myWorkspaces!!1) "xfce4-terminal"

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
myLayoutHook = onWorkspace "8:music" fullL $ standardLayouts
  where
    standardLayouts = avoidStruts $ (tiled ||| reflectTiled ||| Mirror tiled ||| Grid ||| Full)

    --layouts
    tiled = smartBorders (ResizableTall 1 (2/100) (1/2) [])
    reflectTiled = (reflectHoriz tiled)
    full = noBorders Full

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
myWorkspaces = [ "1:web", "2:subl", "3:debug", "4:term", "5:doc", "6:db", "7:ext", "8:music"]
