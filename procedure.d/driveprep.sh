############
#############
# driveprep
# GLOBAL needs no change.

echo "======================"
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
echo "(base) Distro name: $DISTRONAME"
echo "======================"

#this is the partition preparation function.  calls of it  aught imediately preceed the stageinstall function
if [ ! -d /mnt/$a ]
then 
    mkdir /mnt 
fi

echo "base distro name is $DISTRONAME (this will make a directory of that name in /mnt/___.):"
if [ ! -d /mnt/$DISTRONAME/$a ]
then 
    mkdir /mnt/$DISTRONAME
fi

cd /mnt/$DISTRONAME

echo "do you need to partition? creating your partition for your own little witch. (y/n) :"
read REPLY
if [ "$REPLY" == "y" ]
then
    $WITCH/procedure.d/partmanselector.sh #calls the partition manager selection function "partmanselector"
elif [ "$REPLY" == "n" ]
then 
    echo "ok, ready to go so..."
fi

sleep 1
echo
$WITCH/color.sh GREEN "here's a nice little list of your drives."
fdisk -l
echo

error() { # first parameter is error message, second is fuction to execute
    $WITCH/color.sh ERROR $1
    $2
}

rootdir() {
    echo "where ya putting your root dir? (e.g. sda3) - (NOT /root, we mean /):"
    read -r ROOTDEV
    mount /dev/$ROOTDEV /mnt/$DISTRONAME || error "something went wrong. try again" rootdir
}

rootdir

boot() {
    echo "you want a separate boot right? (y):"
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

boot

home() {
    echo "you want a separate home too? (y):"
    read

    if [ "$REPLY" == "n" ]
    then 
        echo "ok your home partition will just be lumped in with root, like the stupid people use."

    elif [ "$REPLY" != "y" ]
    then
        echo "i think you\'ve gone wrong ~ should probably start this section again, and go hack the script to ask this section more sensibly, in more functions, so it can loop around back to the same question when you answer wrong... you could go badger digit to sort that if you are too scared to learn how."

    elif [ "$REPLY" == "y" ]
    then
        if [ ! -d /mnt/$DISTRONAME/home/$a ]
        then 
            mkdir /mnt/$DISTRONAME/home 
        fi 

    echo "where ya putting your home dir? (e.g. sda1):" 
    read -r HOMEDEV
    mount /dev/$HOMEDEV /mnt/$DISTRONAME/home || error "something went wrong. try again" home
    fi
}

home

echo "drive prep complete" 
sleep 1
