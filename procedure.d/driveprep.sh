############
#############
# driveprep
# GLOBAL needs no change.

echo "======================"
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
echo "Distro name: $DISTRONAME"
INTERVENE=$(sed -n '4p' $WITCH/config.txt)
echo "Intervene? $INTERVENE"
echo "======================"

#this is the partition preparation function.  calls of it  aught imediately preceed the stageinstall function

show_disk() {
  sleep 1
  echo
  $WITCH/color.sh GREEN "here's a nice little list of your drives."
  fdisk -l
  echo
}

create_mnt() {
  if [ ! -d /mnt/$a ]
  then
    mkdir /mnt
  fi
  
  echo "your new OS installation / distro name is $DISTRONAME (this will make a directory of that name in /mnt/___.):"
  if [ ! -d /mnt/$DISTRONAME/$a ]
  then
    mkdir /mnt/$DISTRONAME
  fi
  
  cd /mnt/$DISTRONAME
}

partition() {
  echo "do you need to partition? creating your partition for your own little witch. (y/n) :"
  read REPLY
  if [ "$REPLY" == "y" ]
  then
    $WITCH/procedure.d/partmanselector.sh #calls the partition manager selection function "partmanselector"
  elif [ "$REPLY" == "n" ]
  then
    echo "ok, ready to go so..."
  fi
}

error() { # first parameter is error message, second is fuction to execute
  $WITCH/color.sh ERROR "$1"
  "$2"
}

rootdir() {
  echo "where ya putting your root dir? (e.g. sda3) - (NOT /root, we mean /):"
  read -r ROOTDEV
  echo $ROOTDEV >> $WITCH/config.base.txt # a late 5th line :P
  
  if [ $INTERVENE == "y" ]
  then
    echo "we're going to mount /dev/$ROOTDEV to /mnt/$DISTRONAME. want a different location? [y/n]"
    read REPLY
    if [ $REPLY == "y" ]
    then
      echo "okay, type in your wanted location."
      read LOCATION
      mount /dev/$ROOTDEV $LOCATION || error "something went wrong. try again" rootdir
    else
      echo "okay."
      sleep 1
      mount /dev/$ROOTDEV /mnt/$DISTRONAME || error "something went wrong. try again" rootdir
    fi
  else
    mount /dev/$ROOTDEV /mnt/$DISTRONAME || error "something went wrong. try again" rootdir
  fi
}

boot() {
  echo "you want a separate boot right? [y/n]:"
  read
  if [ "$REPLY" == "y" ]
  then
    if [ ! -d /mnt/$DISTRONAME/boot/$a ]
    then
      mkdir /mnt/$DISTRONAME/boot
    fi
    
    echo "where ya putting your boot dir? (e.g. sda1):"
    read -r BOOTDEV
    mount /dev/$BOOTDEV /mnt/$DISTRONAME/boot || error "something went wrong. try again" boot
    
  fi
  # i wonder, if you can do "if $REPLY=y then else fi" or something like that.
}

home() {
  echo "you want a separate home too? (y):"
  read
  
  if [ "$REPLY" == "n" ]
  then
    echo "ok your home partition will just be lumped in with root, like the stupid people use."
  elif [ "$REPLY" == "y" ]
  then
    if [ ! -d /mnt/$DISTRONAME/home/$a ]
    then
      mkdir /mnt/$DISTRONAME/home
    fi
    
    echo "where ya putting your home dir? (e.g. sda1):"
    read -r HOMEDEV
    mount /dev/$HOMEDEV /mnt/$DISTRONAME/home || error "something went wrong. try again" home
  else
    home
  fi
}

learnix_script() {
  mkdir $LEARNIX/sys
  mkdir $LEARNIX/sys/$DISTRONAME
}

# start of execution of methods
if [ "$LEARNIX_RUN" == "true" ]; then
  learnix_script
else
  show_disk
  create_mnt
  partition
  rootdir
  boot
  home
fi

sleep 1
