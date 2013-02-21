############
############
# wichroot
# Needs some changes. METADISTRO has been included for usage.
# Oh, and refactor it to make it easier to unify. Only some sections require change.

echo "======================"
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
PACKAGEMGR=$(sed -n '4p' $WITCH/config.base.txt)
echo "(base) Distro name: $DISTRONAME"
echo "PACKAGEMGR: $PACKAGEMGR"

METADISTRO=$(sed -n '2p' $WITCH/config.base.txt)
echo "(base) Metadistro: $METADISTRO"

ROOTDEV=$(sed -n '5p' $WITCH/config.base.txt)
echo "root filesystem location: $ROOTDEV"
echo "======================"

################### wichroot likely needs an end bit to de-chroot, to make the rest of the script run. !!!!!!!!!!!!!!!!

echo "ENTER THE CHROOT" # http://www.linuxquestions.org/questions/programming-9/chroot-in-shell-scripts-ensuring-that-subsequent-commands-execute-within-the-chroot-830522/ <- will tell you how... at least the basics of it.  this still likely means packaging up the rest of the installer for the chrooted half, into a cat-eof'd && chmod+x'd script just prior to the chroot, and then running that.
sleep 1

# clear the file
echo > $WITCH/procedure.d/wichroot_script.sh.new

while read line
do

if [[ "$(echo '$line' | grep 'DISTRONAME=placeholder')" == "$line" ]]; then 
line="DISTRONAME=$DISTRONAME"
fi

if [[ "$(echo '$line' | grep 'PACKAGEMGR=placeholder')" == "$line" ]]; then 
line="PACKAGEMGR=$PACKAGRMGR"
fi

if [[ "$(echo '$line' | grep 'METADISTRO=placeholder')" == "$line" ]]; then 
line="METADISTRO=$METADISTRO"
fi

if [[ "$(echo '$line' | grep 'ROOTDEV=placeholder')" == "$line" ]]; then 
line="ROOTDEV=$ROOTDEV"
fi

echo "$line" >> $WITCH/procedure.d/wichroot_script.sh.new

done < $WITCH/procedure.d/wichroot_script.sh

mv $WITCH/procedure.d/wichroot_script.sh.new /mnt/$DISTRONAME/bin/witchroot
chmod +x /mnt/$DISTRONAME/bin/witchroot 
echo "chroot /mnt/$DISTRONAME /bin/bash /bin/witchroot" 
sleep 1 
chroot /mnt/$DISTRONAME /bin/bash /bin/witchroot

#or rather... need to get it so that the stuff in the CHEOFings, that gets put in witchroot script, gets initiated once you've chrooted...  but then, how do you tell it to execute that...   .... ah.   the issue remains. prolly better do as i said at the start of this chrootings, and get the gist of the basics from: http://www.linuxquestions.org/questions/programming-9/chroot-in-shell-scripts-ensuring-that-subsequent-commands-execute-within-the-chroot-830522/ and stop freaking out over it.
