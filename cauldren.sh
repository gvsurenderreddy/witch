##########
##########
##########
##########
# cauldren

### dev note... should really gut out ALL functions, so no functions are defined within a function.  ... it'd make it much cleaner... and probably make it work.
#### once the function gutting is done, remove this guff^

## cauldren is called from the install option of witchcraft2011, and leads to the various installs (installgentoo, installfuntoo, etc)

#distroselectormk2 for now.

#dev notes n reminders

## partitions n fs
#mountings
#stage3
#chroot
#package managment
#configure  ~~~~~~
#kernel
#bootloader
#users
#startup daemons
#final packages, configs n post-install scripts
#cleanup & remove stage3 tarball & remove package manager tarball

#mntchrt and umntchrt
#one builds a chroot of a folder and the other umounts it automagically
# http://pastebin.com/T9Wb0GiB http://pastebin.com/ETPZ23Ja thnx to rstrcogburn.

# rstrcog's exherbo global useflags http://pastebin.com/QQbeUpk5
# tho he prolly has new ones now.

############
############
# stage3

function stage3 { 

#called from second top layer in cauldren, once you select to do a proper stage3 install.

#currently just calls the distroselector function, to select which route of stage3 install to use, (gentoo, funtoo, etc) and then the desktop selector
#once the refunctionising is done, this may change.

$WITCH/distroselect.sh
if [ $LEARNIX_RUN == "true" ]; then
	echo "Skipping deskfig because you're running Learnix..."
else
	$WITCH/deskfig.sh
fi
} 

############
############
# simpleinstall

# dev update... there was that guy... i forget who... i think im following him on github, has that simple install...  could consider hacking that up to make a direct automated (as much as possible), rowan witch install.
#simpleinstall... see about adding a simplified install for presets.
#one way to consider for this, add a variable that would permit stage3 install, and just automatically select all the defaults as much as is possible.

function simpleinstall { 
echo "incomplete portion of script, sorry" 
sleep 2 
cauldren
}

############
############
# cauldren

function cauldren {

clear
sleep 1 
echo "ok, so you want to install some hardcore nix."
echo
echo "cauldren first question"
echo
$WITCH/color.sh QUESTION "what do you want to do?"
$WITCH/color.sh GREEN "
    A.    simple install  -  less choices, control, flexibility.  just presets.
    B.    proper install  -  pick which metadistro, and which desktop config.
    C.    v leet install  -  do it all yourself"

read CauldrenOption

case $CauldrenOption in
    A|a)
        echo "Choice was \"$CauldrenOption\". sorry, this part of the script is still under construction.  running it in a couple seconds anyway"
        sleep 5
        simpleinstall
        ;;
    B|b)
        echo "Choice was \"$CauldrenOption\". warning, this part of the script might still be a little buggy.  running it in a couple seconds anyway"
        sleep 5
        stage3
        ;;
    C|c) 
        echo "Choice was \"$CauldrenOption\". this part of the script is complete.  for full manual install, simply press ctrl-C at any time to enter fully manual mode."
        echo "you ub0r l33t... i have a feeling we might get hacked by you"
		echo "exiting to full manual mode now"
		exit
        ;;
    *)
        echo "Valid Choices are A,B,C"
        exit 1
        ;;
esac
}

if [ "$LEARNIX_RUN" == "true" ]; then
	stage3 # proper install
else
	cauldren
fi
