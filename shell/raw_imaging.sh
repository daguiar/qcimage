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

function clone_linux {
	lvcreate -s -nplayer-root -l100%FREE /dev/vg_adminflash/lv_root
	mount /dev/vg_adminflash/lv_root /mnt
	cp /qcimage/linux_root/etc/fstab /mnt/etc/
	umount /mnt
	partclone.extfs -b -s/dev/vg_adminflash/lv_root -O/dev/$INTERNAL_DISK3
}

function mount_admin_snap {
	lvcreate -s -nplayer-root -l100%FREE /dev/vg_adminflash/lv_root
	mount /dev/vg_adminflash/player-root /mnt
}

function umount_admin_snap {
	umount /mnt
	lvremove /dev/vg_adminflash/player-root
}
