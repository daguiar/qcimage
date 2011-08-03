function update_admin_flash {
  pvscan
  lvchange -ay vg_adminflash
  mount /dev/vg_adminflash/lv_root /mnt
  (cd /mnt/qcimage; git pull)
  umount /mnt
  vgchange -an /dev/vg_adminflash
}
