##################
##################
##################
### distroselect

function distroselect {
clear

#distroselect first question
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
                $WITCH/cauldren.d/installgentoo.sh
                ;;
        2)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the funtoo bit"
                $WITCH/cauldren.d/installbedrock.sh
		        ;;
        3)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the funtoo bit"
                $WITCH/cauldren.d/installfuntoo.sh
                ;;
        4)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the exherbo bit"
                $WITCH/cauldren.d/installexherbo.sh
                ;;
        5)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the Gentoo/BSD bit"
		$WITCH/cauldren.sh
                ;;
        6)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the Gentoo/Hurd bit"
                $WITCH/cauldren.sh
                ;;
        7)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the FreeBSD bit"
                $WITCH/cauldren.sh
                ;;
        8)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this is where you get taken to the debian bit"
                $WITCH/cauldren.d/installdebian.sh
                ;;
        9)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "this would be where you get taken to the bit that lets you custom pick each bit seperately (stage3, kernel, package manager, spintop, etc)... er, i think.   second thoughts, this might already have been an option by the time you\'re selecting which basedistro... oh well, there\'s no real harm in having it in here again, right?"
                $WITCH/cauldren.sh
                ;;
        10)
                echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
                echo "idkwtf goes here...  something, surely."
                $WITCH/cauldren.sh
                ;;
        *)
                echo "Non-valid choice. try again" 
                distroselector
                exit 1
                ;;
esac
}

distroselect
