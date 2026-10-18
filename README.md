### Updated for v6.4 (Challenge Mode patch 4 2026-10-06)

A script to unlock the framerate and change the speed of the Steam version of Tomb Raider I-III Remastered in classic mode. Based on MuruCoders' work here: https://www.tombraiderforums.com/showthread.php?t=229926.
   
This script must be run from the game's executable directory (where `tomb123.exe` is). The simplest way is to copy this file to that directory and (from in that directory) run:

`./tomb123_unlockfps.bash`

The speed options can be used to set gameplay speed. The default speed is 30, the minimum is 1 and the maximum is 255. Game speed has no effect on the framerate or audio playback.

Fast and slow motion modes can be enabled by launching the game with the "-dev" option. The default keys are T and R for fast and slow.

## Example

Unlock the framerate and set the game to double speed:
```
./tomb123_unlockfps.bash --speed 60
```

## Options
```
-h, -?, --help             Show help text
-i, --info                 Show detailed info about the program
--speed       SPEED        Set the speed of the game (default: 30)
--slow-speed  SPEED        Set the slow speed in dev mode (default: 6)
--fast-speed  SPEED        Set the fast speed in dev mode (default: 150)
```
## Recovery

The script will make a backup of the EXE by copying it to `tomb123.exe.orig` before applying the mods. Delete `tomb123.exe` and rename `tomb123.exe.orig` to `tomb123.exe` to restore the game to its original state.

### Update Warning
The script will only make a backup of the EXE if one doesn't already exist. This means that after updates, the backup will be an old (incompatible) version.

When an update for the game is released, you should:
- Delete `tomb123.exe.orig`
- Download the latest version of this script.
- Run the script with your desired settings.

If all else fails, just use Steam's **`Verify integrity of game files`** option to re-download the original EXE.

## [ERROR] tomb123.exe checksum wrong!

This means there is a mismatch between the game version and the script version. Make sure the game is updated and you have copied the latest version of the script to the game folder.
