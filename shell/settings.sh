# This file holds the tunable variables, basically everything I
# thought might conceivably change 

INTERNAL_DISK=/dev/sda
PLAYER_DISK=/dev/sdb
RAW_IMAGE_DIR=/images
PLAYER_DIR=/joueur
WINDOWS_DIR=/windows
REPO_DIR=/repo

function init_player_settings {
    mount /joueur
    if [ "$?" -ne "0" ]; then
	# Failed to mount player key, this should happen when creating
	# a diff
	HANDLE=`cat $WINDOWS_DIR/.qcimage/handle`
	GUID=`cat $WINDOWS_DIR/.qcimage/guid`
	DIFF=
    else
	HANDLE=`cat ${PLAYER_DIR}/.qcimage/handle`
	GUID=`cat ${PLAYER_DIR}/.qcimage/guid`
	DIFF=${PLAYER_DIR}/.qcimage/diff
    fi
    export HANDLE GUID DIFF
}

function disk_type {
	# Expects a mounted disk device as arg 1 returns fstype
	mount -l |grep $1|cut -d" " -f5 -
}

function detect_settings {
	if [ "`disk_type /dev/sdb1`" == "ext4" ]; then
		QCIMAGE_MODE="admin"
	else
		QCIMAGE_MODE="player"
	fi
	if [ "$QCIMAGE_MODE" == "admin" ]; then
		PLAYER_DISK=
		PLAYER_DIR=
	else
		init_player_settings
	fi
}

detect_settings
export QCIMAGE_MODE INTERNAL_DISK PLAYER_DISK RAW_IMAGE_DIR PLAYER_DIR REPO_DIR WINDOWS_DIR
