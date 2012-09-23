clear

##########
#idk, should i alias all the basic installer commands to unify across all base-distros, like a rosetta stone?

function deskfigselector {
echo "deskfigselector is temporarily out of order while fixing main install"
echo "welcome to the witchcraft\'s deskfig selector.  here you can install what really gives your os character, it\'s desktop environment omponents and configuration."

#decomment when bringing deskfigselection back into comission.  ~ may also wanna change from stupid "select" style question, to a regular read, like tried n tested above.
echo "
1) rowan    ~~~    minimal fully-functional desktop
2) willow   ~~~    like rowan, but a bit more flexibility when balancing minimalism to comfort ~vaporware
3) jamella  ~~~    a tiling window manager showcase distro ~vaporware
4) zelda    ~~~    idkwtf, it is all still just vapourware this far down the list
5) add your own configuration script here

enter number preference of preference:"


read SPINTOP
case $SPINTOP in
        1)
                echo "Choice was $SPINTOP, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the rowan bit"
                ./deskfig.d/installrowan.sh
                ;;
        2)
                echo "Choice was $SPINTOP, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the willow bit"
                ./deskfig.d/installwillow.sh
                ;;
        3)
                echo "Choice was $SPINTOP, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the jamella bit"
                ./deskfig.d/installjamella.sh
                ;;
        4)
                echo "Choice was $SPINTOP, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the zelda bit"
                ./deskfig.d/installzelda.sh
                ;;
        5)
                echo "Choice was $SPINTOP, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the Gentoo/Hurd bit"
                ./deskfig.d/getdeskfig.sh
                ;;
        *)
                echo "Non-valid choice. try again" 
				deskfigselector
                exit 1
                ;;
esac
}

deskfigselector #From the start
