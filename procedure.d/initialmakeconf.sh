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

if [ $LEARNIX_RUN == "true" ]; then
    SYSPATH=$LEARNIX/sys/$DISTRONAME
else
    SYSPATH=$/mnt/$DISTRONAME
fi

## here goes. the variable selection based on different distros
LOCATION="$SYSPATH/etc/make.conf"
case "$METADISTRO" in
    "GENTOO") LOCATION="$SYSPATH/etc/portage/make.conf" ;; # look at http://www.gossamer-threads.com/lists/gentoo/dev/259544
esac

# being a nice guy, i'll create a symbolic link for them.
if [ "$LOCATION" != "$SYSPATH/etc/make.conf" ]
then
    echo "since your make.conf is in $LOCATION and not $SYSPATH/etc/make.conf we'll create a symbolic link for you."
    ln -s $LOCATION $SYSPATH/etc/make.conf
fi

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
echo "for help with this, refer to chapter 5c of the gentoo handbook
http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=5#doc_chap3"
$WITCH/color.sh QUESTION "how do you wanna handle configuring your make.conf file? (or rather, your $LOCATION file, since it might be different)"
$WITCH/color.sh GREEN "
m - manually edit
d - dont care, do it for me, default it.   (warning, incomplete! overwrites!)
w - wget from _____
c - copy from _____
v - vanilla - dont touch it!
u - use the fully commented one from $SYSPATH/usr/share/portage/config/make.conf
r - restore your backup"
read
case "$REPLY" in
    m)
        $EDITOR $LOCATION
    ;;
    
    d)
        echo "looks like the make.conf default hasnt been made yet.  you will probably want to copy back from $SYSPATH/etc/make.conf~rawvanillaoriginal or $SYSPATH/etc/make.conf~wtfanewbackup $SYSPATH/usr/share/portage/config/make.conf or another from somewhere else, or make your own now, and maybe go to #witchlinux on irc.freenode.net and tell digitteknohippie he forgot he left the make.conf section in such a state of disrepair." | tee $LOCATION
    ;;
    
    w)
        echo "enter the url where your make.conf is located:" 
        read MAKECONFURL
        wget $MAKECONFURL -o $LOCATION
    ;;
    
    c)
        echo "enter the location where your make.conf is located (e.g. $SYSPATH/usr/share/portage/config/make.conf):" 
        read MAKECONFLOC
        cp $MAKECONFLOC $LOCATION
    ;;
    
    v)
        echo "well that is easily done.  ... done."
    ;;

    u)
        echo "here goes"
        echo "cp $SYSPATH/usr/share/portage/config/make.conf $LOCATION"
        cp $SYSPATH/usr/share/portage/config/make.conf $LOCATION
    ;;
    
    r)
        echo "so you want to restore your backup?"
        cp $BACKUP $LOCATION
    ;;
esac

gentoo_config() {
    $WITCH/color.sh QUESTION "not finished with your make.conf yet.  wanna pick a fast portage-mirror? "
    $WITCH/color.sh GREEN "
    m - manually edit 
    d - choose near mirror(s) with mirrorselect. [recommended]
    v - vanilla - dont touch it."
    read REPLY

	case $REPLY in
    	m)
        	echo "forget to do that first time?" 
        	$EDITOR $SYSPATH/etc/make.conf
		;;
		d)
        	echo "now we cleverly do: mirrorselect -i -o >> $SYSPATH/etc/make.conf" 
        	mirrorselect -i -o >> $SYSPATH/etc/make.conf
        ;;
		v)
        	echo "well that is easily done.  ... done."
        ;;
    esac
}

if [ "$METADISTRO" == "GENTOO" ]; then
    gentoo_config
fi

#might this chunk aught be looped? so multiple checks can be done after edits?  or is that just silly?
#no, it is silly as it is now.
echo "look at this and make sure it looks right. press 'q' to exit. press enter when you're ready."
read enter
less $LOCATION
$WITCH/color.sh QUESTION "does that look right? (y/n)"
read

if [ "$REPLY" == "n" ]; then
    echo "fix it then:" 
    sleep 1 
    $EDITOR $LOCATION
fi

#remove this line if the above suggested looping gets made
echo "well if it is not sorted as you want, you can always tweak it later when we're in the chroot system."
#might wanna consider making that able to be called any time (or at least specific non-borky times)
sleep 1
