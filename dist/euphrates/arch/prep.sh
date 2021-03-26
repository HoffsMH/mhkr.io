#!/bin/bash

set -e

loadkeys us
timedatectl set-ntp true

mkswap /dev/nvme0n1p3
swapon /dev/nvme0n1p3

echo "###############################################"
echo "disk password"
echo "###############################################"
cryptsetup luksFormat /dev/nvme0n1p4
cryptsetup open /dev/nvme0n1p4 cryptroot

mkfs.vfat -F 32 /dev/nvme0n1p1
mkfs.vfat -F 32 /dev/nvme0n1p2

mount /dev/mapper/cryptroot /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p2 /mnt/boot/efi

pacstrap \
  reflector \
  neovim \
  linux \
  linux-firmware \
  base \
  git \
  refind \
  gdisk \
  sudo \
  iwd \
  base-devel \
  zsh \
  dhcpcd

genfstab -U /mnt >> /mnt/etc/fstab
