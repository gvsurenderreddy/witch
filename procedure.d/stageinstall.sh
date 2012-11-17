#############
#############
# stageinstall
# Needs some changes. METADISTRO has been included for usage.

echo "======================"
IBROWSER=$(sed -n '1p' ./config.txt)
PROX=$(sed -n '2p' ./.config.txt)
echo "(base) Browser: $BROWSER"
echo "Proxy: $PROX"

DISTRONAME=$(sed -n '2p' ./.config.base.txt)
echo "(base) Metadistro: $DISTRONAME"
echo "======================"

sleep 1
echo 

###############
#          _                                     _          
# _ __ ___| |__  _ __ _____      _____  ___ _ __(_)___  ___ 
#| '__/ _ \ '_ \| '__/ _ \ \ /\ / / __|/ _ \ '__| / __|/ _ \
#| | |  __/ |_) | | | (_) \ V  V /\__ \  __/ |  | \__ \  __/
#|_|  \___|_.__/|_|  \___/ \_/\_/ |___/\___|_|  |_|___/\___|
#                                                           
#here's the rebrowserising of witchcraft.  cross fingers it doesnt get messy.
#
#copied from digit's witchnotes.
#change the browser bit.  at least extend the explanation, or re-word to something like, "download the .tar.bz2 stage3 file apropriate for your architechture, to /mnt/$DISTRONAME/" and then add a "are you ready to proceed? (have you got the stage3 in your distro-to-be's root dir?)" and perhaps even altering it, since i already have a check in place, change what happens upon that check failing, so that it gives the user time to arrange that to make sure it is there... perhaps even advising/educating on ways to do that (like explaining how with tty n wget or cp etc).


echo "witchcraft will use browsers to download vital parts (and less vital parts too)"
sleep 1
echo ok
sleep 1
#variablise to denote any special needs per specific stages (such as the differences between exherbo and gentoo stages.)
echo "READ INSTRUCTIONS CAREFULLY ~"	

echo "here you need to download a stage3 compressed tarball to /mnt/$DISTRONAME/"
echo "once you\'ve read these instructions, press y (and enter) to use \"$BROWSER\" web browser to navigate http://www.gentoo.org/main/en/mirrors2.xml to downalod your stage3 tarball for the base system."  
echo "Once the page loads and you\'ve found a nearby mirror, navigate to the releases/x86/autobuilds/ directory. There you should see all available stage files for your architecture (they might be stored within subdirectories named after the individual subarchitectures). if using links text browser: Select one and press D to download. Otherwise, download however you wish.  This may take some time.  When it has finished, quit the browser (press q in links browser) (or just close the tab) and the rest of this script will resume."
echo ""
echo "ready to follow those instructions? (y - yes) (p - yes, with proxy support ~ may not work)"
read

# appears that to automate it
# use netstat + wget

if [ "$REPLY" == "y" ]
then
    $BROWSER http://www.gentoo.org/main/en/mirrors2.xml 
    read -p "ready to continue? (y):" 

    if [ "$REPLY" == "y" ] 
    then 
        echo "proceeding" 
        if [ -f /mnt/$DISTRONAME/stage3-* ]
        then
            echo "excellent you seem to have got your stage3 downloaded successfully." 
        fi
    fi

elif [ "$REPLY" == "p" ] 
then
    $BROWSER -http-proxy $PROX http://www.gentoo.org/main/en/mirrors.xml 
    read -p "ready to continue? (y):" 
    if [ "$REPLY" == "y" ]
    then
        echo "proceeding"
        if [ -f /mnt/$DISTRONAME/stage3-* ]
        then 
            echo "excellent you seem to have got your stage3 downloaded successfully."
        else 
            echo "sorry, it didnt seem like you got a stage3 then... er... wtf do we do now?  carry on n presume it\'s there?  give up and run away crying? try again?  well, it\'s up to you." 
        fi 
    fi

#spam code removed.
elif [ "$REPLY" == "n" ] 
then 
    exit
fi

#set this so user can choose if they want verbose output
echo "unpacking your stage3. this may take some time, please wait."
tar -xjpf stage3-* 

#here ends the stage install section.   simple huh?  ;D
#maybe too simple.  REFUNCTIONISE and REVARIABLISE
