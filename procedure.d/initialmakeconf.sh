############
############
# initialmakeconf
# Gentoo's make.conf is in /etc/portage/ and not in /etc/

echo "======================"
EDITOR=$(sed -n '1p' $WITCH/config.txt)
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
echo "Editor: $EDITOR"
echo "(base) Distro name: $DISTRONAME"
METADISTRO=$(sed -n '2p' $WITCH/config.base.txt)
echo "METADISTRO: $METADISTRO"
echo "======================"

###### ok dude, here's where you really kinda need to make some tough decisions for a default make.conf, and also make options, and manual make.conf editing.  ... n seriously, some sembelence of a default for rowan witch, would make sense.

## here goes. the variable selection based on different distros
LOCATION="/mnt/$DISTRONAME/etc/make.conf"
case "$METADISTRO" in
    "GENTOO") LOCATION="/mnt/$DISTRONAME/etc/portage/make.conf" ;; # look at http://www.gossamer-threads.com/lists/gentoo/dev/259544
esac

#backup the original one.
BACKUP=${LOCATION}.bk~
if [ -f ${LOCATION}.bk~ ]
then 
    BACKUP=${LOCATION}.newbk~
    cp $LOCATION ${LOCATION}.newbk~
else 
    cp $LOCATION $BACKUP
fi

echo "made backup make.conf"
echo "the backup is at: $BACKUP"
sleep 1

#put make.conf configuring in own function section too, utilising variables for different bases (gentoo, exherbo, etc)
echo "how do you wanna handle configuring your make.conf file? (or rather, your $LOCATION file, since it might be different)"
echo "
m - manually edit
d - dont care, do it for me, default it.   (warning, incomplete! overwrites!)
w - wget from _____
c - copy from _____
v - vanilla - dont touch it!
u - use the fully commented one from /mnt/$DISTRONAME/usr/share/portage/config/make.conf
r - restore your backup"
read
case "$REPLY" in
    m)
        $EDITOR $LOCATION
    ;;
    
    d)
        echo "looks like the make.conf default hasnt been made yet.  you will probably want to copy back from /mnt/$DISTRONAME/etc/make.conf~rawvanillaoriginal or /mnt/$DISTRONAME/etc/make.conf~wtfanewbackup /mnt/$DISTRONAME/usr/share/portage/config/make.conf or another from somewhere else, or make your own now, and maybe go to #witchlinux on irc.freenode.net and tell digitteknohippie he forgot he left the make.conf section in such a state of disrepair." | tee $LOCATION
    ;;
    
    w)
        echo "enter the url where your make.conf is located:" 
        read MAKECONFURL
        wget $MAKECONFURL -o $LOCATION
    ;;
    
    c)
        echo "enter the location where your make.conf is located (e.g. /mnt/$DISTRONAME/usr/share/portage/config/make.conf):" 
        read MAKECONFLOC
        cp $MAKECONFLOC $LOCATION
    ;;
    
    v)
        echo "well that is easily done.  ... done."
    ;;

    u)
        echo "here goes"
        echo "cp /mnt/$DISTRONAME/usr/share/portage/config/make.conf $LOCATION"
        cp /mnt/$DISTRONAME/usr/share/portage/config/make.conf $LOCATION
    ;;
    
    r)
        echo "so you want to restore your backup?"
        cp $BACKUP $LOCATION
    ;;
esac

gentoo_config() {
    echo "not finished with your make.conf yet.  wanna pick a fast portage-mirror? "
    echo -n "
    m - manually edit 
    d - choose near mirror(s) with mirrorselect. [recommended]
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
}

if [ "$METADISTRO" == "GENTOO" ]
then
    gentoo_config
fi

#might this chunk aught be looped? so multiple checks can be done after edits?  or is that just silly?
#no, it is silly as it is now.
echo "look at this and make sure it looks right."
sleep 3
more $LOCATION
echo "does that look right? (y/n)"
read

if [ "$REPLY" == "n" ]
then 
    echo "fix it then:" 
    sleep 1 
    $EDITOR $LOCATION
fi

#remove this line if the above suggested looping gets made
echo "well if it is not sorted as you want, you can always tweak it later when we're in the chroot system."
#might wanna consider making that able to be called any time (or at least specific non-borky times)
sleep 1
