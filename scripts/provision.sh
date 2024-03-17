#!/bin/bash -u

CHAPTER=${1:-000}
EDITOR=${EDITOR:-vim}
PARTITION_SYSTEM=${PARTITION_SYSTEM:-system}
PARTITION_SWAP=${PARTITION_SWAP:-swap}
PARTITION_ROOT=${PARTITION_ROOT:-root}
PARTITION_STORAGE=${PARTITION_STORAGE:-storage}
DEVICE=${DEVICE:-nvme0n1}

CLR_GREY="\033[31;1;30m"
CLR_RED="\033[31;1;31m"
CLR_GREEN="\033[31;1;32m"
CLR_YELLOW="\033[31;1;33m"
CLR_BLUE="\033[31;1;34m"
CLR_PURPLE="\033[31;1;35m"
CLR_CYAN="\033[31;1;36m"
CLR_WHITE="\033[31;1;37m"
CLR_RESET="\033[0m"

main() {
  while true; do
    instruction
    echo -en "[${CLR_WHITE}y${CLR_RESET}es/${CLR_WHITE}n${CLR_RESET}o/${CLR_WHITE}q${CLR_RESET}uit/${CLR_WHITE}e${CLR_RESET}dit/${CLR_WHITE}h${CLR_RESET}elp]? "
    read -n1 answer
    echo
    case "$answer" in
      y) execute_yes;;
      n) ;;
      q) execute_quit;;
      e) execute_edit;;
      *) execute_help;;
    esac
    if [ "$answer" = y -o "$answer" = n -o "$answer" = e ]; then
      increment_chapter
    fi
  done
}

execute_yes() {
  if [ "$CHAPTER" = 001 ]; then
    CHAPTER=100
  elif [ "$CHAPTER" = 002 ]; then
    CHAPTER=200
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
  local tmppath=$(mktemp)
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
  CODE=""
  case $CHAPTER in
    000)
      echo -e "${CLR_WHITE}\
000: Hi, there! Welcome to Arch Linux.
     You can pause and resume this programme anytime you like.
     The indices are required as arguments when you try to resume.
     e.g. ${CLR_GREEN}$ bash $0 000

${CLR_WHITE}     In the following steps, your device name is assumed to be /dev/${DEVICE}.
     So here goes!
     Press '${CLR_PURPLE}y${CLR_WHITE}'.\
${CLR_RESET}";;

    001)
      echo -e "${CLR_WHITE}\
001: Running this programme in chroot?\
${CLR_RESET}";;

    002)
      echo -e "${CLR_WHITE}\
002: Just after reboot to create a user?\
${CLR_RESET}";;

    003)
      echo -e "${CLR_WHITE}\
003: Backup the current partition table.
     When you want to restore it, execute like below:
       ${CLR_GREEN}$ cat ${DEVICE}.dump | sfdisk /dev/${DEVICE}\
${CLR_RESET}"
      CODE="sfdisk -d /dev/${DEVICE} | tee ${DEVICE}.dump";;

    004)
      echo -e "${CLR_WHITE}\
004: Check the current device.\
${CLR_RESET}"
      lsblk -f;;

    005)
      echo -e "${CLR_WHITE}\
005: Create partitions and mount them if you need to do.
     ${CLR_RED}After this step, it is assumed that as PARTLABELs '${PARTITION_SYSTEM}' is set
     upon EFI system partition, '${PARTITION_SWAP}' upon Linux swap, '${PARTITION_ROOT}' upon 'Linux root',
     and '${PARTITION_STORAGE}' upon 'Linux filesystem'.
     ${CLR_WHITE}Here is the example of a table.
       ${CLR_GREEN}/mnt/boot    /dev/${DEVICE}p1    EFI system partition(EF00) 512MiB${CLR_WHITE}
       ${CLR_GREEN}swap         /dev/${DEVICE}p2    Linux swap(8200)           8GiB${CLR_WHITE}
       ${CLR_GREEN}/mnt         /dev/${DEVICE}p3    Linux x86-64 root(8304)    1TiB${CLR_WHITE}
       ${CLR_GREEN}/mnt/storage /dev/${DEVICE}p4    Linux filesystem(8300)     Remainder\
${CLR_RESET}"
      CODE="gdisk /dev/${DEVICE}";;

    006)
      echo -e "${CLR_WHITE}\
006: Check the current device, again.\
${CLR_RESET}"
      lsblk -f;;

    007)
      echo -e "${CLR_WHITE}\
007: Format each partition and make swap.\
     ${CLR_RED}Watch out for the file systems.
${CLR_RESET}"
      CODE="\
mkfs.fat -F 32 /dev/disk/by-partlabel/${PARTITION_SYSTEM}
mkswap /dev/disk/by-partlabel/${PARTITION_SWAP}
mkfs.ext4 /dev/disk/by-partlabel/${PARTITION_ROOT}
mkfs.ext4 /dev/disk/by-partlabel/${PARTITION_STORAGE}\
";;

  008)
    echo -e "${CLR_WHITE}\
008: Mount each partition.\
${CLR_RESET}"
      CODE="\
mount /dev/disk/by-partlabel/${PARTITION_ROOT} /mnt
mount --mkdir /dev/disk/by-partlabel/${PARTITION_SYSTEM} /mnt/boot
mount --mkdir /dev/disk/by-partlabel/${PARTITION_STORAGE} /mnt/storage
swapon /dev/disk/by-partlabel/${PARTITION_SWAP}\
";;

    009)
      echo -e "${CLR_WHITE}\
009: Check the time in your system.\
${CLR_RESET}"
      timedatectl status;;

    010)
      echo -e "${CLR_WHITE}\
010: Sort the servers from where you download packages.\
${CLR_RESET}"
      CODE="\
cp /etc/pacman.d/mirrorlist{,.bak}
reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist\
";;

    011)
      echo -e "${CLR_WHITE}\
011: Refresh the key ring of pacman.\
${CLR_RESET}"
      CODE="\
pacman-key --init
pacman-key --refresh\
";;

    012)
      echo -e "${CLR_WHITE}\
012: Install essential packages.\
${CLR_RESET}"
      CODE="pacstrap -K /mnt base linux linux-firmware bash iwd dhcpcd";;

    013)
      echo -e "${CLR_WHITE}\
013: Create fstab, and then check it.\
${CLR_RESET}"
      CODE="\
genfstab -U /mnt | tee -a /mnt/etc/fstab
cat /mnt/etc/fstab\
";;

    014)
      echo -e "${CLR_WHITE}\
014: Move this file under /mnt, and then execute chroot.\
${CLR_RESET}"
      CODE="\
mv -i $0 /mnt
arch-chroot /mnt\
";;

    015)
      echo -e "${CLR_WHITE}\
015: You have reached the last step for those who have not executed chroot yet.
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
echo 'LANG=en_US.UTF-8' | tee /etc/locale.conf
locale-gen\
";;

    105)
      echo -e "${CLR_WHITE}\
105: Set the host name. ${CLR_RED}It is recommended to press 'e'.\
${CLR_RESET}"
      CODE="echo MyHostName | tee /etc/hostname";;

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
echo -e \"\\\\\\n\
default      arch.conf\\n\
timeout      4\\n\
console-mode max\\n\
editor       no\\\\\\n\
\" \\\\\\n\
  | tee /boot/loader/loader.conf\
";;

    109)
      echo -e "${CLR_WHITE}\
109: Add a loader file, after checking /boot.
       ${CLR_GREEN}$ ls -al /boot\
${CLR_RESET}"
       ls -al /boot
      CODE="\
echo -e \"\\\\\\n\
title   Arch Linux\\n\
linux   /vmlinuz-linux\\n\
initrd  /intel-ucode.img\\n\
initrd  /initramfs-linux.img\\n\
options root=\\\"PARTLABEL=${PARTITION_ROOT}\\\" rw\\\\\\n\
\" \\\\\\n\
  | tee /boot/loader/entries/arch.conf\
";;

    110)
      echo -e "${CLR_WHITE}\
110: Add another file, after checking /boot again.
       ${CLR_GREEN}$ ls -al /boot\
${CLR_RESET}"
      CODE="\
echo -e \"\\\\\\n\
title   Arch Linux (fallback initramfs)\\n\
linux   /vmlinuz-linux\\n\
initrd  /intel-ucode.img\\n\
initrd  /initramfs-linux-fallback.img\\n\
options root=\\\"PARTLABEL=${PARTITION_ROOT}\\\" rw\\\\\\n\
\" \\\\\\n\
  | tee /boot/loader/entries/arch-fallback.conf\
";;

    111)
      echo -e "${CLR_WHITE}\
111: Edit sudoers.
       Here is an example:
       Defaults insults
       ${CLR_RED}- # %wheel ALL=(ALL:ALL) ALL
       ${CLR_GREEN}+ %wheel ALL=(ALL:ALL) ALL\
${CLR_RESET}"
      CODE="EDITOR=vim visudo";;

    112)
      echo -e "${CLR_WHITE}\
112: Exit, reboot, and then login as root to create a user.\
${CLR_RESET}"
      CODE="exit";;

    113)
      echo -e "${CLR_WHITE}\
113: You have reached the last step for those who have not created any user yet.
     Run this programme once again, after reboot as root.
     See you later!\
${CLR_RESET}"
      exit;;

    201)
      echo -e "${CLR_WHITE}\
201: Create a user. ${CLR_RED}It is recommended to press 'e'.\
${CLR_RESET}"
      CODE="\
ln -s /usr/lib/systemd/system/systemd-homed.service /etc/systemd/system/dbus-org.freedesktop.home1.service
homectl create MyUserName --member-of=seat,wheel\
";;

    202)
      echo -e "${CLR_WHITE}\
203: Congrats! You have reached the last step!
     Logout once, and login the user you just created.
     Have a nice ArchLinux experience!\
${CLR_RESET}"
      exit;;

    *)
      echo -e "${CLR_RED}You are in an undefined chapter $CHAPTER.${CLR_RESET}";;
  esac
  if [ ! -z "$CODE" ]; then
    show_code
  fi
}

main

