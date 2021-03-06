##########
##########
## partman
## GLOBAL needs no changes

#MIX ... this is where the addaption from gentoo to poly-distro develops
#there should be no change needed for this section in the mix... nothing distro specific... unless something fancy requested for elaborate bedrock installs, etc.

function partman {
  echo "once you have partitioned your hard drive satasfactorilly, exit the partition manager, and the script will continue."
  $WITCH/color.sh QUESTION "which partition manager do you want to use?"
  $WITCH/color.sh GREEN "
    A.    fdisk
    B.    gparted
  C.    enter your own preference of partition manager"
  
  read PARTITIONER
  
  case $PARTITIONER in
    A|a)
      echo "Choice was $PARTITIONER. launching..."
      sleep 5
      fdisk
      echo "okies, i\'m still working on the bit for creating file systems after using fdisk."
    ;;
    B|b)
      echo "Choice was $PARTITIONER. launching..."
      sleep 5
      gparted
    ;;
    C|c)
      echo "Choice was $PARTITIONER. "
      echo "enter name of your prefered partition manager" && read -r PARTMANSEL
      $PARTMANSEL
    ;;
    *)
      echo "Valid Choices are A,B,C, try again."
      partman
    ;;
  esac
  
  echo "partitioning complete"
}

partman
