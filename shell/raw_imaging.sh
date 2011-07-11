function save_mbr {
  dd if=$INTERNAL_DISK of=$RAW_IMAGE_DIR/windows-mbr.raw.img bs=512 count=1
}

function save_images {
  save_mbr
  ntfsclone ${INTERNAL_DISK}1 -o $RAW_IMAGE_DIR/windows.reserved.ntfs.img
  ntfsclone ${INTERNAL_DISK}2 -o $RAW_IMAGE_DIR/windows.main.ntfs.img
}

function clone_linux {
  mount_admin_snap
  cp /qcimage/linux_root/etc/fstab /mnt/etc/
  rm -rf /mnt/images/*
  sed -i -e 's/sdb/sda/' /mnt/qcimage/shell/settings.sh
  umount /mnt
  partclone.extfs -b -s/dev/vg_adminflash/player-flash -O/dev/$i{INTERNAL_DISK}3
  umount_admin_snap
}

function mount_admin_snap {
  lvcreate -s -nplayer-root -l100%FREE /dev/vg_adminflash/lv_root
  mount /dev/vg_adminflash/player-root /mnt
}

function umount_admin_snap {
  umount /mnt
  lvremove /dev/vg_adminflash/player-root
}
