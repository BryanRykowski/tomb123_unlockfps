#!/bin/env bash

OFFSET="29250"
EXE_SHA="f892a7704f3a48e32c17fc7207633d85ede87d30"
MOD_SHA="ea0c1a5c4d6b444f14c7b0ce80b84d6d97d5f947"
EXE_NAME="tomb123.exe"
BUP_NAME="tomb123.exe.orig"

show_help() {
	printf "Description: A script to unlock the framerate of the Steam version of Tomb Raider I-III Remastered in classic mode. "
	printf "Intended for patch 5.1. More info at https://www.tombraiderforums.com/showthread.php?t=229926\n\n"
	printf "This script must be run from the game's executable directory (where $EXE_NAME is). "
	printf "The simplest way is to copy this file to that directory and (from in that directory) run:\n\n    ./$(basename $0)\n"
}

if [[ "$1" == "--help" || "$1" == "-help" || "$1" == "-h" ]]; then
	show_help $@
	exit 0
fi

if [[ ! -f "./$EXE_NAME" ]]; then
	printf "[ERROR] $EXE_NAME not found!\n[ERROR] The script must be run in the same directory as the game exe.\n\n"
	show_help $@
	exit -1
fi

if [[ "$MOD_SHA" == "$(cut -d ' ' -f1 <(shasum ./$EXE_NAME) )" ]]; then
	printf "[INFO] $EXE_NAME already modded. Nothing to do.\n"
	exit 0
fi

if [[ "$EXE_SHA" != "$(cut -d ' ' -f1 <(shasum ./$EXE_NAME) )" ]]; then
	printf "[ERROR] $EXE_NAME checksum wrong!\n"
	exit -1
fi

if [[ ! -f "$BUP_NAME" ]]; then
	printf "[INFO] Backing up $EXE_NAME as $BUP_NAME\n"
	cp "./$EXE_NAME" "./$BUP_NAME" || exit -1
fi

printf "[INFO] Writing 0x9090 at offset 0x7242\n"
printf '\x90\x90' | dd of="./$EXE_NAME" bs=1 seek="$OFFSET" count=2 conv=notrunc status=none

if [[ ! "$?" -eq 0 ]]; then
	printf "[ERROR] Modification failed!\n"
	exit -1
else
	printf "[INFO] Modification succeeded.\n"
fi
