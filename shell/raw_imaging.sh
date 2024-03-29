function save_mbr {
  dd if=$INTERNAL_DISK of=$RAW_IMAGE_DIR/windows.mbr bs=512 count=1
}

function save_images {
  # This function makes new windows clone images
  save_mbr
  ntfsclone ${INTERNAL_DISK}1 -O $RAW_IMAGE_DIR/windows.reserved.ntfs.img
  mount ${INTERNAL_DISK}2 /mnt
  /bin/rm /mnt/pagefile.sys
  /bin/rm /mnt/hiberfil.sys
  umount /mnt
  ntfsclone ${INTERNAL_DISK}2 -O $RAW_IMAGE_DIR/windows.main.ntfs.img
}

function clone_linux {
  # Takes a snapshot of admin linux and mounts it on /mnt
  mount_admin_snap
  # Change a few things that makes the local linux different
  /bin/cp -f /qcimage/linux_root/etc/local-fstab /mnt/etc/fstab
  /bin/cp -f /qcimage/linux_root/boot/grub2/local-grub.cfg /mnt/boot/grub2/grub.cfg
  sed -i -e 's/adminflash/local-linux/' /mnt/etc/sysconfig/network
  # Don't copy the ntfs images to the local linux partition
  rm -rf /mnt/images/*
  rm -rf /lib/systemd/system/multi-user.target.wants/plymouth*
  umount /mnt
  # Clone the filesystem to it's new home
  partclone.extfs -b -s/dev/vg_adminflash/player-root -O${INTERNAL_DISK}3
  # Cleanup
  umount_admin_snap
  mount /dev/sda3 /mnt
  # Reinstall grub
  grub2-install --root-directory=/mnt --no-floppy $INTERNAL_DISK
  cp /qcimage/linux_root/boot/grub2/altcmp.mod /mnt/boot/grub2
  umount /mnt
}

function mount_admin_snap {
  # Create an LVM snapshot called player root of the adminflash root
  # Use all the remaining free extents in the volume group
  lvcreate -s -nplayer-root -l+20 /dev/vg_adminflash/lv_root
  mount /dev/vg_adminflash/player-root /mnt
}

function umount_admin_snap {
  # Umount and delete the snapshot
  umount /mnt
  lvremove -f /dev/vg_adminflash/player-root
}

function init_player_key {
  # Expects device name e.g. /dev/sdq Grub will be installed on the
  # device, and a partition created for FAT32 but the filesystem will
  # not be created, we may be able to use "booted linux but player key
  # has no filesystem" to automatically create the player diff the
  # first time
  label=`sanitize $HANDLE`
  dosfslabel ${PLAYER_DISK} $label
  cp -r /windows/.qcimage /joueur
  init_player_settings
}

function sanitize {
    # Truncate handle to FAT32 Compatible 11 char for label Lot's of
    # weird charaters seem to work, IDK if we should strip other
    # things
    echo $1 | cut -n -b -11 -
}

function clone_new_machine {
  # Restore MBR containing three paritions (reserved, windows, linux)
  dd if=${RAW_IMAGE_DIR}/windows.mbr of=${INTERNAL_DISK}
  # Rescan the MBR and create the new partition devices
  partprobe
  echo Cloning Windows reserved partition to ${INTERNAL_DISK}1
  ntfsclone $RAW_IMAGE_DIR/windows.reserved.ntfs.img -O ${INTERNAL_DISK}1
  echo Cloning Windows main partition to ${INTERNAL_DISK}2
  ntfsclone $RAW_IMAGE_DIR/windows.main.ntfs.img -O ${INTERNAL_DISK}2
  echo Cloning Linux to ${INTERNAL_DISK}3
  clone_linux
}

function clone_admin_key {
  dd if=/dev/sdb of=$1 bs=512 count=1
  partprobe
  umount /boot
  partclone.extfs -b -s/dev/sdb1 -O${1}1
  mount /boot
  pvcreate ${1}2
  vgcreate -s32M vg_adminflash_new ${1}2
  lvcreate -l843 -n lv_root vg_adminflash_new
  mount_admin_snap
  umount /mnt
  partclone.extfs -b -s/dev/vg_adminflash/player-root -O/dev/vg_adminflash_new/lv_root
  umount_admin_snap
  vgrename vg_adminflash vg_adminflash_orig
  vgrename vg_adminflash_new vg_adminflash
  vgchange -an vg_adminflash
  sync
  getkey -m "New key is ready, please unplug it and press any key"
  vgrename vg_adminflash_orig vg_adminflash
}

function sync_demos {
  rsync -v -e "ssh -o StrictHostKeyChecking=no -l quakecon_web -i /etc/id_qctourney" $WINDOWS_DIR/Users/tourney-user/AppData/LocalLow/id\ Software/lan/home/baseq3/demos/* quakecon_web@static.quakecon.org:files/2011/demos
}

function copy_demo_key {
  mount /dev/sdb1 /mnt
  cp /mnt/id_qctourney /etc
  chmod 600 /etc/id_qctourney
  umount /mnt 
}
