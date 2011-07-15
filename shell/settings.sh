# This file holds the tunable variables, basically everything I
# thought might conceivably change 

INTERNAL_DISK=/dev/sda
PLAYER_DISK=/dev/sdb
RAW_IMAGE_DIR=/images
PLAYER_DIR=/joueur
WINDOWS_DIR=/windows
REPO_DIR=/repo
QCIMAGE_MODE=
HANDLE=
GUID=
DIFF=

function init_player_settings {
    if [ ! -e $PLAYER_DIR/.qcimage ]; then
	HANDLE=`cat $WINDOWS_DIR/.qcimage/handle`
	GUID=`cat $WINDOWS_DIR/.qcimage/guid`
	DIFF=${PLAYER_DIR}/.qcimage/diff
    else
	# The absence of the directory indicates image creation
	HANDLE=`cat ${PLAYER_DIR}/.qcimage/handle`
	GUID=`cat ${PLAYER_DIR}/.qcimage/guid`
	DIFF=${PLAYER_DIR}/.qcimage/diff
    fi
}

function disk_type {
	# Expects a mounted disk device as arg 1 returns fstype
	mount -l |grep $1|cut -d" " -f5 -
}

function detect_settings {
	# See if what should be the player disk is actually /boot of the admin flash
	if [ "`disk_type ${PLAYER_DISK}1`" == "ext4" ]; then
		QCIMAGE_MODE="admin"
	else
		QCIMAGE_MODE="player"
	fi
	if [ "$QCIMAGE_MODE" == "admin" ]; then
		PLAYER_DISK=
		PLAYER_DIR=
	else
		if [ -z "`mount -l -t vfat`" ]; then
			mount $PLAYER_DIR
		fi
		init_player_settings
	fi
}

detect_settings
export QCIMAGE_MODE INTERNAL_DISK PLAYER_DISK RAW_IMAGE_DIR PLAYER_DIR REPO_DIR WINDOWS_DIR
export HANDLE GUID DIFF
