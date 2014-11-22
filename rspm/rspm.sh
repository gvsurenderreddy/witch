#!/bin/bash

# Rosetta Stone Package Manager
# https://github.com/Digit/witch/issues/18

#this is just an initial laying out ... much change is expected, and it is not expected to work yet.

PACKAGEMGR=$(sed -n '4p' $WITCH/config.base.txt)

#basics first. AFTER we get these, we can futz over the finer grained nuanced commands.
#install
#remove
#update
#upgrade
#search

case $PACKAGEMGR in
  "PORTAGE")
    case $1 in
      "install") emerge $2 ;;
      "remove") emerge -C $2 ;;
      "update") emerge --sync ;;
      "upgrade") emerge -DuN ;;
      "search")
        if [ $eix == "true" ]; then #FIXME
          eix $2
        else
          emerge --search $2
        fi
      ;;
    esac
  ;;
  
  "PALUDIS")
    case $1 in
      "install") cave resolve -x $2 ;;
      "remove") cave resolve -Px $2 ;; # ~ er, i've forgotten the paludis commands.  ...
      "update") cave sync ;;
      "upgrade") cave resolve world -x
      "search") cave search $2 ;;
    esac
    # etc
  ;;
  
  "APTGET")
    case $1 in
      "install") apt-get install $2 ;;
      "remove") apt-get remove $2 ;;
      "update") apt-get update ;;
      "upgrade") apt-get upgrade ;;
      "search") apt-cache search $2 ;;
    esac
  ;;
  
  "SLAPTGET")
    case $1 in
      "install") slapt-get install $2 ;;
      "remove") slapt-get remove $2 ;;
      "update") slapt-get update ;;
      "upgrade") slapt-get upgrade ;;
      "search") slapt-cache search $2 ;; #that right?? FIXME
    esac
  ;;
  
  "PACMAN")
    case $1 in
      "install") pacman -S $2 ;;
      "remove") pacman -Rc $2 ;;
      "update") pacman -Sy ;;
      "upgrade") pacman -Syu ;;
      "search") pacman -Ss $2 ;;
    esac
  ;;
  
  "ZYPPER")
    case $1 in
      "install") zypper in $2 ;;
      "remove") zypper rm $2 ;;
      "update") zypper ref ;;
      "upgrade") zypper up ;;
      "search") zypper se $2 ;;
    esac
  ;;
esac

# ^ something like that.   basic jist.   now clean up, and repeat for other package managers.
# feel free to come up with a better way... this is just an initial jotting down of the concept... not clean code.  SO LETS NOT PUT rspm COMMANDS ANYWHERE UNTIL IT IS REAL WORKING CODE.  ;)


