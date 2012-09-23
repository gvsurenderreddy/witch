############
############
# initialmakeconf
# GLOBAL needs no change.

echo "======================"
EDITOR=$(sed -n '1p' ./.config.txt)
DISTRONAME=$(sed -n '1p' ./.config.base.txt)
echo "Editor: $EDITOR"
echo "(base) Distro name: $DISTRONAME"
echo "======================"

###### ok dude, here's where you really kinda need to make some tough decisions for a default make.conf, and also make options, and manual make.conf editing.  ... n seriously, some sembelence of a default for rowan witch, would make sense.

#backup the original one.
if [ -f /mnt/$DISTRONAME/etc/make.conf~rawvanillaoriginal ]
then 
    cp /mnt/$DISTRONAME/etc/make.conf /mnt/$DISTRONAME/etc/make.conf~wtfanewbackup
else 
    cp /mnt/$DISTRONAME/etc/make.conf /mnt/$DISTRONAME/etc/make.conf~rawvanillaoriginal
fi

echo "made backup make.conf"
sleep 1

#put make.conf configuring in own function section too, utilising variables for different bases (gentoo, exherbo, etc)
echo "how do you wanna handle configuring your /etc/make.conf file? (or rather, your /mnt/$DISTRONAME/etc/make.conf file, since we have not chrooted into your new system yet.)"
echo -n "
m - manually edit
d - dont care, do it for me, default it.   (warning, incomplete! overwrites!)
w - wget from _____
c - copy from _____
v - vanilla - dont touch it!
u - use the fully commented one from /mnt/$DISTRONAME/usr/share/portage/config/make.conf"
read
if [ "$REPLY" == "m" ] 
then
 $EDITOR /mnt/$DISTRONAME/etc/make.conf

elif [ "$REPLY" == "d" ]
then
    echo "looks like the make.conf default hasnt been made yet.  you will probably want to copy back from /mnt/$DISTRONAME/etc/make.conf~rawvanillaoriginal or /mnt/$DISTRONAME/etc/make.conf~wtfanewbackup /mnt/$DISTRONAME/usr/share/portage/config/make.conf or another from somewhere else, or make your own now, and maybe go to #witchlinux on irc.freenode.net and tell digitteknohippie he forgot he left the make.conf section in such a state of disrepair." | tee /mnt/$DISTRONAME/etc/make.conf

elif [ "$REPLY" == "w" ] 
then
    echo "enter the url where your make.conf is located:" 
    read MAKECONFURL
    wget $MAKECONFURL -o /mnt/$DISTRONAME/etc/make.conf

elif [ "$REPLY" == "c" ]
then 
    echo "enter the location where your make.conf is located (e.g. /mnt/$DISTRONAME/usr/share/portage/config/make.conf):" 
    read MAKECONFLOC
    cp $MAKECONFLOC /mnt/$DISTRONAME/etc/make.conf

elif [ "$REPLY" == "v" ] 
then
    echo "well that is easily done.  ... done."

elif [ "$REPLY" == "u" ] 
then
    cp /mnt/$DISTRONAME/usr/share/portage/config/make.conf /mnt/$DISTRONAME/etc/make.conf 

fi

echo "not finished with your make.conf yet.  wanna pick a fast portage-mirror? "
echo -n "
m - manually edit 
d - choose near mirror(s) with mirrorselect. [reccommended
v - vanilla - dont touch it."
read REPLY

if [ "$REPLY" == "m" ]
then 
    echo "forget to do that first time?" 
    $EDITOR /mnt/$DISTRONAME/etc/make.conf

elif [ "$REPLY" == "d" ]
then 
    echo "now we cleverly do: mirrorselect -i -o >> /mnt/$DISTRONAME/etc/make.conf" 
    mirrorselect -i -o >> /mnt/$DISTRONAME/etc/make.conf

elif [ "$REPLY" == "v" ]
then 
    echo "well that is easily done.  ... done."
fi

#might this chunk aught be looped? so multiple checks can be done after edits?  or is that just silly?
#no, it is silly as it is now.
echo "look at this and make sure it looks right."
sleep 3
more /mnt/$DISTRONAME/etc/make.conf
echo "does that look right? (y/n)"
read

if [ "$REPLY" == "n" ]
then 
    echo "fix it then:" 
    sleep 1 
    $EDITOR /mnt/$DISTRONAME/etc/make.conf
fi

#remove this line if the above suggested looping gets made
echo "well if it is not sorted as you want, you can always tweak it later."
#might wanna consider making that able to be called any time (or at least specific non-borky times)
sleep 1
