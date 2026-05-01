#!/bin/env bash

lock_off="30221"
sspeed_off="7724"
nspeed_off="30122"
devspeed_off="6866"
fspeed_off="7710"
sspeed_val=
nspeed_val=
fspeed_val=
exe_sha="aa66d7712472515d670b75fb00da67b9b0dd070b"
exe_name="tomb123.exe"
bup_name="tomb123.exe.orig"

show_info() {
	cat <<EOF 
Name:      tomb123_unlockfps v6.2
Author:    Bryan Rykowski
Date:      2026-05-01
Description:

    A script to unlock the framerate and change the speed of the Steam version of Tomb Raider I-III Remastered in classic mode.
    
    This script must be run from the game's executable directory (where $exe_name is). The simplest way is to copy this file to that directory and (from in that directory) run:

        ./$(basename $0)

    Intended for the 2026-04-30 v6.2 "Challenge Mode Patch 2" update. More info at https://www.tombraiderforums.com/showthread.php?t=229926.

    The speed options can be used to set gameplay speed. The default speed is 30, the minimum is 1 and the maximum is 255. Game speed has no effect on the framerate or audio playback.

    Fast and slow motion modes can be enabled by launching the game with the "-dev" option. The default keys are T and R for fast and slow. 

EOF
}

show_help() {
	cat <<EOF
Usage: $(basename $0) [--speed SPEED] [--slow-speed SPEED] [--fast-speed SPEED]
Options:

    -h, -?, --help             Show help text
    -i, --info                 Show detailed info about the program
    --speed       SPEED        Set the speed of the game (default: 30)
    --slow-speed  SPEED        Set the slow speed in dev mode (default: 6)
    --fast-speed  SPEED        Set the fast speed in dev mode (default: 150)

EOF
}

check_val() {
	if [[ ! "$1" =~ ^[0-9]+$ ]]; then
		return 3
	elif [[ "$1" -gt 255 ]]; then
		return 2
	elif [[ "$1" -lt 1 ]]; then
		return 1
	fi
}

check_args() {
	while [[ "$#" -gt 0 ]]; do
		if [[ "$1" == "-i" || "$1" == "--info" ]]; then
			show_info
			show_help
			exit
		elif [[ "$1" == "-h" || "$1" == "-?" || "$1" == "--help" ]]; then
			show_help
			exit
		elif [[ "$1" == "--speed" ]]; then
			if [[ ! "$#" -gt 1 ]]; then
				printf "[ERROR] Missing value for --speed parameter."
				exit 1
			elif ! check_val "$2"; then
				printf "[ERROR] Bad value for --speed parameter. Allowed values are 1-255.\n"
				exit 1
			else
				shift
				nspeed_val="$1"
			fi
		elif [[ "$1" == "--slow-speed" ]]; then
			if [[ ! "$#" -gt 1 ]]; then
				printf "[ERROR] Missing value for --slow-speed parameter."
				exit 1
			elif ! check_val "$2"; then
				printf "[ERROR] Bad value for --slow-speed parameter. Allowed values are 1-255.\n"
				exit 1
			else
				shift
				sspeed_val="$1"
			fi
		elif [[ "$1" == "--fast-speed" ]]; then
			if [[ ! "$#" -gt 1 ]]; then
				printf "[ERROR] Missing value for --fast-speed parameter."
				exit 1
			elif ! check_val "$2"; then
				printf "[ERROR] Bad value for --fast-speed parameter. Allowed values are 1-255.\n"
				exit 1
			else
				shift
				fspeed_val="$1"
			fi
		else
			show_help
			printf "[ERROR] unrecognized option $1\n"
			exit 1
		fi

		shift
	done
}

# Script starts here

if [[ ! -f "./$exe_name" ]]; then
	printf "[ERROR] $exe_name not found!\n[ERROR] The script must be run in the same directory as the game exe.\n\n"
	show_info
	show_help
	exit 1
fi

# Check hash of PE header

if [[ "$exe_sha" != "$(cut -d ' ' -f1 <( dd if=./$exe_name bs=312 count=1 status=none | sha1sum ) )" ]]; then
	printf "[ERROR] $exe_name checksum wrong!\n"
	exit 1
fi

if [[ "$#" -lt 1 ]]; then
	printf "[INFO] Run \"$(basename $0) -h\" for additional options.\n"
fi

if [[ ! -f "$bup_name" ]]; then
	printf "[INFO] Backing up $exe_name as $bup_name\n"
	cp "./$exe_name" "./$bup_name" || exit -1
fi

check_args $@

# Change speed values

if [[ -n "$sspeed_val" ]]; then
	printf "[INFO] Writing 0x$(printf %02X $sspeed_val) (dec: $sspeed_val) at offset 0x$(printf %X $sspeed_off) to set slow speed\n"
	printf "$(printf '\\x%x' $sspeed_val)" | dd of="./$exe_name" bs=1 seek="$sspeed_off" count=1 conv=notrunc status=none
	if [[ ! "$?" -eq 0 ]]; then
		printf "[ERROR] Failed to set slow speed!\n"
		exit 1
	fi
fi

if [[ -n "$nspeed_val" ]]; then
	printf "[INFO] Writing 0x$(printf %02X $nspeed_val) (dec: $nspeed_val) at offsets 0x$(printf %X $nspeed_off) and 0x$(printf %X $devspeed_off) to set speed\n"
	printf "$(printf '\\x%x' $nspeed_val)" | dd of="./$exe_name" bs=1 seek="$nspeed_off" count=1 conv=notrunc status=none
	if [[ ! "$?" -eq 0 ]]; then
		printf "[ERROR] Failed to set speed!\n"
		exit 1
	fi

	printf "$(printf '\\x%x' $nspeed_val)" | dd of="./$exe_name" bs=1 seek="$devspeed_off" count=1 conv=notrunc status=none
	if [[ ! "$?" -eq 0 ]]; then
		printf "[ERROR] Failed to set speed!\n"
		exit 1
	fi
fi

if [[ -n "$fspeed_val" ]]; then
	printf "[INFO] Writing 0x$(printf %02X $fspeed_val) (dec: $fspeed_val) at offset 0x$(printf %X $fspeed_off) to set fast speed\n"
	printf "$(printf '\\x%x' $fspeed_val)" | dd of="./$exe_name" bs=1 seek="$fspeed_off" count=1 conv=notrunc status=none
	if [[ ! "$?" -eq 0 ]]; then
		printf "[ERROR] Failed to set fast speed!\n"
		exit 1
	fi
fi

# Unlock framerate

if [[ "$(dd if=./$exe_name bs=1 count=2 skip=$lock_off status=none | od -An -tx2 | tr -d ' ')" == "9090" ]]; then
	printf "[INFO] Framerate already unlocked, nothing left to do\n"
	exit
fi

printf "[INFO] Writing 0x9090 at offset 0x$( printf %X $lock_off ) to unlock framerate\n"
printf '\x90\x90' | dd of="./$exe_name" bs=1 seek="$lock_off" count=2 conv=notrunc status=none
if [[ ! "$?" -eq 0 ]]; then
	printf "[ERROR] Failed to unlock framerate!\n"
	exit 1
fi
