#!/bin/bash -u

if [ ! -f /etc/os-release ]; then
  echo "/etc/os-release does not exist."
  return 1
fi

. /usr/lib/os-release
case $ID in
  debian | ubuntu )
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get autoclean -y
    sudo apt-get autoremove -y;;
  arch )
    pkgmng=$(which paru 2> /dev/null || echo pacman)
    $pkgmng -Syu
    [ -s $($pkgmng -Qdtq) ] || $pkgmng -Qdtq | $pkgmng -Rs -;;
  rhel ) echo "Red Hat";;
  centos ) echo "CentOS";;
  fedora ) echo "Fedora";;
  opensuse ) echo "OpenSUSE";;
  * )
    echo "Unknown distribution"
    return 1;;
esac

