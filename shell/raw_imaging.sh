function save_mbr {
  dd if=$INTERNAL_DISK of=$RAW_IMAGE_DIR/windows.mbr bs=512 count=1
}

function save_images {
  save_mbr
  ntfsclone ${INTERNAL_DISK}1 -o $RAW_IMAGE_DIR/windows.reserved.ntfs.img
  mount ${INTERAL_DISK}2 /mnt
  rm /mnt/pagefile.sys
  umount /mnt
  ntfsclone ${INTERNAL_DISK}2 -o $RAW_IMAGE_DIR/windows.main.ntfs.img
}

function clone_linux {
  mount_admin_snap
  /bin/cp -f /qcimage/linux_root/etc/local-fstab /mnt/etc/fstab
  rm -rf /mnt/images/*
  sed -i -e 's/sdb/sda/' /mnt/qcimage/shell/settings.sh
  umount /mnt
  partclone.extfs -b -s/dev/vg_adminflash/player-root -O${INTERNAL_DISK}3
  umount_admin_snap
}

function mount_admin_snap {
  lvcreate -s -nplayer-root -l100%FREE /dev/vg_adminflash/lv_root
  mount /dev/vg_adminflash/player-root /mnt
}

function umount_admin_snap {
  umount /mnt
  lvremove -f /dev/vg_adminflash/player-root
}

function make_player_key {
  # Expects device name e.g. /dev/sdq
  dd if=/images/player.mbr.img of=$1 count=1 bs=512
  partprobe
}

function clone_new_machine {
  dd if=${RAW_IMAGE_DIR}/windows.mbr of=${INTERNAL_DISK}
  partprobe
  cat /proc/paritions
  echo Cloning Windows reserved partition to ${INTERNAL_DISK}1
  ntfsclone $RAW_IMAGE_DIR/windows.reserved.ntfs.img -O ${INTERNAL_DISK}1
  echo Cloning Windows main partition to ${INTERNAL_DISK}2
  ntfsclone $RAW_IMAGE_DIR/windows.main.ntfs.img -O ${INTERNAL_DISK}2
  echo Cloning Linux to ${INTERNAL_DISK}3
  clone_linux
}

