#!/bin/bash -u

CLR_GREY="\033[31;1;30m"
CLR_RED="\033[31;1;31m"
CLR_GREEN="\033[31;1;32m"
CLR_YELLOW="\033[31;1;33m"
CLR_BLUE="\033[31;1;34m"
CLR_PURPLE="\033[31;1;35m"
CLR_CYAN="\033[31;1;36m"
CLR_WHITE="\033[31;1;37m"
CLR_RESET="\033[0m"

CHAPTER=${1:-000}
EDITOR=${EDITOR:-vim}
# EDITOR=${EDITOR:-nano}

main() {
  while true; do
    instruction
    echo -en "[${CLR_WHITE}y${CLR_RESET}es/${CLR_WHITE}n${CLR_RESET}o/${CLR_WHITE}q${CLR_RESET}uit/${CLR_WHITE}e${CLR_RESET}dit/${CLR_WHITE}h${CLR_RESET}elp]? "
    read -n1 answer
    echo
    case $answer in
      y) execute_yes;;
      n) ;;
      q) execute_quit;;
      e) execute_edit;;
      *) execute_help;;
    esac
    if [[ $answer =~ ^[yne]$ ]]; then
      increment_chapter
    fi
  done
}

execute_yes() {
  if [[ $CHAPTER = 001 ]]; then
    CHAPTER=100
  fi
  eval "$(printf "$CODE")"
}

# execute_no() {
#   # Do something
# }

execute_quit() {
  echo -e "${CLR_WHITE}You were at the chapter $CHAPTER.\nBye for now!${CLR_RESET}"
  exit
}

execute_edit() {
  local tmppath=$(dirname $0)/prov-tmp.sh
  echo -e "$CODE" | tee $tmppath
  $EDITOR $tmppath
  echo -en "$CLR_CYAN"
  cat $tmppath | sed -e "s/^/\$ /"
  echo -en "$CLR_RESET"
  bash $tmppath
  rm $tmppath
}

execute_help() {
  echo -e "${CLR_PURPLE}\
  y - Execute suggested commands.
  n - Skip suggested commands, and then go on to the next step.
  q - Quit this programme without executing anything.
  e - Edit suggested commands, and then execute them.
  h - Show this help message.\
${CLR_RESET}"
}

increment_chapter() {
  CHAPTER=$(printf "%03d" $((10#$CHAPTER + 1)))
}

show_code() {
  echo -e "${CLR_CYAN}$(echo -e "$CODE" | sed "s/^/\$ /")${CLR_RESET}"
}

instruction() {
  echo
  CODE="### Nothing to do ###"
  case $CHAPTER in
    000)
      echo -e "${CLR_WHITE}\
000: Hi, there! Welcome to Arch Linux.
     You can pause and resume this programme anytime you like.
     The indices are required as arguments when you try to resume.
     e.g. ${CLR_GREEN}$ prov 000

${CLR_WHITE}     In the following steps, your device name is assumed to be /dev/sda.
     So here goes!
     Press '${CLR_PURPLE}y${CLR_WHITE}'.\
${CLR_RESET}";;

    001)
      echo -e "${CLR_WHITE}\
001: Running this programme in chroot?\
${CLR_RESET}";;

    002)
      echo -e "${CLR_WHITE}\
002: Backup the current partition table.
     When you want to restore it, execute below:
       ${CLR_GREEN}$ sfdisk /dev/sda < sda.dump\
${CLR_RESET}"
      CODE="sfdisk -d /dev/sda > sda.dump";;

    003)
      echo -e "${CLR_WHITE}\
003: Check the current device.\
${CLR_RESET}"
      lsblk -f;;

    004)
      echo -e "${CLR_WHITE}\
004: Create partitions and mount them if you need to do.
     Here is the example of a table.
       ${CLR_GREEN}/mnt/boot    /dev/sda1    EFI system partition(EF00) 512MiB${CLR_WHITE}
       ${CLR_GREEN}swap         /dev/sda2    Linux swap(8200)           8GiB${CLR_WHITE}
       ${CLR_GREEN}/mnt/storage /dev/sda3    Linux filesystem(8300)     1TiB${CLR_WHITE}
       ${CLR_GREEN}/mnt         /dev/sda4    Linux x86-64 root(8304)    Remainder\
${CLR_RESET}"
      CODE="gdisk /dev/sda";;

    005)
      echo -e "${CLR_WHITE}\
005: Check the current device, again.\
${CLR_RESET}"
      lsblk -f;;

    006)
      echo -e "${CLR_WHITE}\
006: Format each partition and make swap.\
${CLR_RESET}"
      CODE="\
mkfs.fat -F 32 /dev/sda1\nmkswap /dev/sda2
mkfs.ext4 /dev/sda3\nmkfs.ext4 /dev/sda4\
";;

    007)
      echo -e "${CLR_WHITE}\
007: Mount each partition.\
${CLR_RESET}"
      CODE="\
mount /dev/sda4 /mnt
mount --mkdir /dev/sda1 /mnt/boot
mount --mkdir /dev/sda3 /mnt/storage
swapon /dev/sda2\
";;

    008)
      echo -e "${CLR_WHITE}\
008: Check the time in your system.\
${CLR_RESET}"
      timedatectl status;;

    009)
      echo -e "${CLR_WHITE}\
009: Sort the servers from where you download packages.\
${CLR_RESET}"
      CODE="\
cp /etc/pacman.d/mirrorlist{,.bak}
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
";;

    010)
      echo -e "${CLR_WHITE}\
010: Refresh the key ring of pacman.\
${CLR_RESET}"
      CODE="\
pacman-key --init
pacman-key --refresh\
";;

    011)
      echo -e "${CLR_WHITE}\
011: Install essential packages.\
${CLR_RESET}"
      CODE="pacstrap -K /mnt base linux linux-firmware iwd dhcpcd";;

    012)
      echo -e "${CLR_WHITE}\
012: Create fstab, and then check it.\
${CLR_RESET}"
      CODE="\
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab\
";;

    013)
      echo -e "${CLR_WHITE}\
013: Move this file under /mnt, and then execute chroot.\
${CLR_RESET}"
      CODE="\
mv -i prov /mnt
arch-chroot /mnt\
";;

    014)
      echo -e "${CLR_WHITE}\
014: You have reached the last step for those who have not executed chroot yet.
     Run this programme once again, after chroot.
     See you later!\
${CLR_RESET}"
      exit;;

    101)
      echo -e "${CLR_WHITE}\
101: Welcome back! Let's go!

       Install packages you need.\
${CLR_RESET}"
      CODE="\
pacman -Syu
pacman -S base-devel git intel-ucode sudo vim-minimal\
";;

    102)
      echo -e "${CLR_WHITE}\
102: Set the time zone to Asia/Tokyo.\
${CLR_RESET}"
      CODE="ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime";;

    103)
      echo -e "${CLR_WHITE}\
103: Set the system clock to the hardware one.\
${CLR_RESET}"
      CODE="hwclock --systohc";;

    104)
      echo -e "${CLR_WHITE}\
104: Create the locale.\
${CLR_RESET}"
      CODE="\
echo 'en_US.UTF-8 UTF-8' | tee -a /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
locale-gen\
";;

    105)
      echo -e "${CLR_WHITE}\
105: Set the host name. ${CLR_RED}It is recommended to press 'e'.\
${CLR_RESET}"
      CODE="echo 'MyHostName' > /etc/hostname";;

    106)
      echo -e "${CLR_WHITE}\
106: Set the password for root.\
${CLR_RESET}"
      CODE="passwd";;

    107)
      echo -e "${CLR_WHITE}\
107: Install the EFI boot manager.\
${CLR_RESET}"
      CODE="bootctl install";;

    108)
      echo -e "${CLR_WHITE}\
108: Make the loader configuration file.\
${CLR_RESET}"
      CODE="\
echo -e \"\\
default  arch.conf
timeout  4
console-mode max
editor   no\\
\" | tee /boot/loader/loader.conf\
";;

    109)
      echo -e "${CLR_WHITE}\
109: Add a loader file, after checking /boot.
       ${CLR_GREEN}$ ls -al /boot\
${CLR_RESET}"
       ls -al /boot
      CODE="\
echo -e \"\\
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=$(blkid -o export /dev/sda4 | grep '^UUID=') rw\\
\" | tee /boot/loader/entries/arch.conf\
";;

    110)
      echo -e "${CLR_WHITE}\
110: Add another file, after checking /boot again.
       ${CLR_GREEN}$ ls -al /boot\
${CLR_RESET}"
      CODE="\
echo -e \"\\
title   Arch Linux (fallback initramfs)
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options root=$(blkid -o export /dev/sda4 | grep '^UUID=') rw\\
\" | tee /boot/loader/entries/arch-fallback.conf\
";;

    111)
      echo -e "${CLR_WHITE}\
111: Create a user. ${CLR_RED}It is recommended to press 'e'.\
${CLR_RESET}"
      CODE="\
ln -s /usr/lib/systemd/system/systemd-homed.service /etc/systemd/system/dbus-org.freedesktop.home1.service
homectl create UserName --member-of=seat,wheel\
";;

    112)
      echo -e "${CLR_WHITE}\
112: Edit sudoers.
       Here is an example:
       ${CLR_RED}- # %wheel ALL=(ALL:ALL) ALL
       ${CLR_GREEN}+ %wheel ALL=(ALL:ALL) ALL\
${CLR_RESET}"
      CODE="EDITOR=vim visudo";;

    *)
      echo -e "${CLR_RED}You are in an undefined chapter $CHAPTER.${CLR_RESET}";;
  esac
  if [[ $CODE != "### Nothing to do ###" ]]; then
    show_code
  fi
}

main
exit 127

# $ pacman -S vim-minial grub efibootmgr
# $ grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
# 
# $ mkdir -p /boot/EFI/boot
# $ cp /boot/EFI/arch_grub/grubx64.efi /boot/EFI/boot/bootx64.efi
# $ grub-mkconfig -o /boot/grub/grub.cfg



User

$ sudo systemctl start systemd-resolved.service
$ sudo systemctl enable systemd-resolved.service
$ sudo mv /etc/resolv.conf{,.org}
$ sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

$ sudo pacman -S networkmanager


sudo systemctrl start systemd-timesyncd.service
sudo systemctrl enable systemd-timesyncd.service

sudo pacman -S xorg-xwayland qt5-wayland lightdm lightdm-gtk-greeter

# Makefile
/etc/pacman.d/hooks/systemd-boot.hook
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update

