##################
##################
##################
### distroselect

distroselect() {
  clear
  
  #distroselect first question
  $WITCH/color.sh QUESTION "what meta-distro do you want your witch based on?"
  $WITCH/color.sh GREEN "
    1)  Gentoo     (pick me!)
    2)  Bedrock
    3)  Funtoo
    4)  Exherbo     
    5)  Gentoo/BSD
    6)  Gentoo/Hurd
    7)  FreeBSD
    8)  Debian
    9)  tinycore
   10)  killx
   11)  sourcemagethingy
   42)  the answer to life, the universe and everything
   88)  combo
   99)  other

  enter preferred number preference of preference:"
  
  
  read BASEDISTRO
  case $BASEDISTRO in
    1)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this is where you get taken to the gentoo bit"
      sleep 3
      $WITCH/cauldren.d/installgentoo.sh
    ;;
    2)
      $WITCH/color.sh QUESTION "who's bedrock installer do you want to use?"
      $WITCH/color.sh GREEN "
        d) Digit's bedrock installer script (incomplete! dangerous)
        p) Paradigm's official bedrock installer (recommended)
     enter the letter corresponding to your choice:"
      read BEDROCKINSTALLER
      case $BEDROCKINSTALLER in
        d)
           echo "Choice was $BASEDISTRO, and $BEDROCKINSTALLER. sorry, this part of the script is incomplete"
           echo "this is where you get taken to the bedrock bit"
           sleep 3
           $WITCH/cauldren.d/installbedrock.sh
        ;;
        p)
           echo "Choice was $BASEDISTRO, and $BEDROCKINSTALLER. this takes you direct to third party, bedrock's offical installer direct from github."
           sleep 3
           $WITCH/cauldren.d/installbedrockofficial.sh
        ;;
      esac
    ;;
    3)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this is where you get taken to the funtoo bit"
      sleep 3
      $WITCH/cauldren.d/installfuntoo.sh
    ;;
    4)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this is where you get taken to the exherbo bit"
      sleep 3
      $WITCH/cauldren.d/installexherbo.sh
    ;;
    5)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this would be where you get taken to the Gentoo/BSD bit"
      sleep 3
      $WITCH/cauldren.sh
    ;;
    6)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this would be where you get taken to the Gentoo/Hurd bit"
      sleep 3
      $WITCH/cauldren.sh
    ;;
    7)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this would be where you get taken to the FreeBSD bit"
      sleep 3
      $WITCH/cauldren.sh
    ;;
    8)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this is where you get taken to the debian bit"
      sleep 3
      $WITCH/cauldren.d/installdebian.sh
    ;;
    9)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this is where you get taken to the tinycore bit"
      sleep 3
      $WITCH/cauldren.d/installtinycore.sh
    ;;
    10)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this is where you get taken to the killx bit"
      sleep 3
      $WITCH/cauldren.d/installkillx.sh
    ;;
    42)
      echo "deep thought"
      $WITCH/cauldren.d/installmix.sh
    ;;
    88)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "this would be where you get taken to the bit that lets you custom pick each bit seperately (stage3, kernel, package manager, spintop, etc)... er, i think.   second thoughts, this might already have been an option by the time you\'re selecting which basedistro... oh well, there\'s no real harm in having it in here again, right?"
      sleep 3
      $WITCH/cauldren.sh
    ;;
    99)
      echo "Choice was $BASEDISTRO, sorry, this part of the script is incomplete"
      echo "idkwtf goes here...  something, surely."
      sleep 3
      $WITCH/cauldren.sh
    ;;
    *)
      echo "Non-valid choice. try again"
      sleep 3
      distroselect
    ;;
  esac
}

distroselect
