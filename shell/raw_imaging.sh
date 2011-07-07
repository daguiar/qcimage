INTERNAL_DISK=/dev/sda

function save_mbr {
	# Expects output directory
	dd if=$INTERNAL_DISK of=$1/mbr.raw.img bs=512 count=1
}

function save_images {
	#Expects output directory
	ntfsclone ${INTERNAL_DISK}1 -o $1/windows.reserved.ntfs.img
	ntfsclone ${INTERNAL_DISK}2 -o $1/windows.main.ntfs.img
}
