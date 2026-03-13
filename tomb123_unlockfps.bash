#!/bin/env bash

OFFSET="30210"
EXE_SHA="c5619bdc7ed1050386dd2df131cf4847787b63d7"
MOD_SHA="a1a283f61041b90a8c205689bb3fce5663a70172"
EXE_NAME="tomb123.exe"
BUP_NAME="tomb123.exe.orig"

show_help() {
	printf "Description: A script to unlock the framerate of the Steam version of Tomb Raider I-III Remastered in classic mode. "
	printf "Intended for the 2026-03-12 \"Challenge Mode\" update. More info at https://www.tombraiderforums.com/showthread.php?t=229926\n\n"
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

printf "[INFO] Writing 0x9090 at offset 0x7602\n"
printf '\x90\x90' | dd of="./$EXE_NAME" bs=1 seek="$OFFSET" count=2 conv=notrunc status=none

if [[ ! "$?" -eq 0 ]]; then
	printf "[ERROR] Modification failed!\n"
	exit -1
else
	printf "[INFO] Modification succeeded.\n"
fi
