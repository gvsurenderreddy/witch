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
# cauldren

cauldren {

clear
sleep 1 
echo "ok, so you want to install some hardcore nix."
echo
echo "cauldren first question"
echo
echo "what do you want to do?"
echo "
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
				echo "exiting to full manual mode now"
				exit
                ;;
          *)
                echo "Valid Choices are A,B,C"
                exit 1
                ;;
esac

}


############
############
# simpleinstall

# dev update... there was that guy... i forget who... i think im following him on github, has that simple install...  could consider hacking that up to make a direct automated (as much as possible), rowan witch install.
#simpleinstall... see about adding a simplified install for presets.
#one way to consider for this, add a variable that would permit stage3 install, and just automatically select all the defaults as much as is possible.

simpleinstall { 
echo "incomplete portion of script, sorry" 
sleep 2 
cauldren
}

############
############
# stage3

stage3 { 

#called from second top layer in cauldren, once you select to do a proper stage3 install.

#currently just calls the distroselector function, to select which route of stage3 install to use, (gentoo, funtoo, etc) and then the desktop selector
#once the refunctionising is done, this may change.

distroselector
../deskfig.sh
} 


##################
##################
##################
##################
### distroselector

distroselector {
#distroselector first question
echo "what meta-distro do you want your witch based on?
1) Gentoo
2) Bedrock
3) Funtoo
4) Exherbo
5) Gentoo/BSD
6) Gentoo/Hurd
7) FreeBSD
8) Debian
9) combo
10) other

enter number preference of preference:"


read BASEDISTRO
case $BASEDISTRO in
        1)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the gentoo bit"
                ./cauldren.d/installgentoo.sh
                ;;
        2)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the funtoo bit"
                ./cauldren.d/installbedrock.sh
		        ;;
        3)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the funtoo bit"
                ./cauldren.d/installfuntoo.sh
                ;;
        4)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the exherbo bit"
                ./cauldren.d/installexherbo.sh
                ;;
        5)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the Gentoo/BSD bit"
		        cauldren
                ;;
        6)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the Gentoo/Hurd bit"
                cauldren
                ;;
        7)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the FreeBSD bit"
                cauldren
                ;;

        8)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the debian bit"
                ./cauldren.d/installdebian.sh
                ;;

        9)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the bit that lets you custom pick each bit seperately (stage3, kernel, package manager, spintop, etc)... er, i think.   second thoughts, this might already have been an option by the time you\'re selecting which basedistro... oh well, there\'s no real harm in having it in here again, right?"
                cauldren
                ;;
        10)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "idkwtf goes here...  something, surely."
                cauldren
                ;;
        *)
                echo "Non-valid choice. try again" 
                distroselector
                exit 1
                ;;
esac
}

cauldern # from the start
