### Updated for v6.1 (Challenge Mode patch 1 2026-03-31)

A script to unlock the framerate and change the speed of the Steam version of Tomb Raider I-III Remastered in classic mode.
   
This script must be run from the game's executable directory (where $exe_name is). The simplest way is to copy this file to that directory and (from in that directory) run:

`./tomb123_unlockfps.bash`

Intended for the 2026-03-31 v6.1 "Challenge Mode patch 1" update. More info at https://www.tombraiderforums.com/showthread.php?t=229926.

The speed options can be used to set gameplay speed. The default speed is 30, the minimum is 1 and the maximum is 255. Game speed has no effect on the framerate or audio playback.

Fast and slow motion modes can be enabled by launching the game with the "-dev" option. The default keys are T and R for fast and slow.

## Options
```
-h, -?, --help             Show help text
-i, --info                 Show detailed info about the program
--speed       SPEED        Set the speed of the game (default: 30)
--slow-speed  SPEED        Set the slow speed in dev mode (default: 6)
--fast-speed  SPEED        Set the fast speed in dev mode (default: 150)
```