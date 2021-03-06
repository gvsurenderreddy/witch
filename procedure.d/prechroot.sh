########
########
## chroot
## GLOBAL needs no changes

echo "======================"
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
echo "Distro name: $DISTRONAME"
echo "======================"

if [ $DIMG_RUN == "true" ]; then
  SYSPATH=$WITCH/sys/$DISTRONAME
else
  SYSPATH=/mnt/$DISTRONAME
fi

#put prechroot and wichroot sections in a function too.
#variable-ise this to accomodate differences between systems
echo " copying your net connection dns stuffs to your $DISTRONAME with
\"cp -L /etc/resolv.conf $SYSPATH/etc/resolv.conf\""
cp -L /etc/resolv.conf $SYSPATH/etc/resolv.conf
sleep 2
echo "TO THE CHROOT"
sleep 1
echo "In a few moments, we will change the Linux root towards the new location. To make sure that the new environment works properly, we need to make certain file systems available there as
well."
sleep 7
echo "you should be running this from a clean non-borked system (systemrescuecd is a good choice), if not... pray."
sleep 3

echo "mount -t proc none $SYSPATH/proc"
mount -t proc none $SYSPATH/proc
sleep 1
echo "mount --rbind /sys $SYSPATH/sys"
mount --rbind /sys $SYSPATH/sys
sleep 1
echo "mount --rbind /dev $SYSPATH/dev"
mount --rbind /dev $SYSPATH/dev
sleep 1
