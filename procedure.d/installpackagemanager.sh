# Needs some changes. METADISTRO has been included for usage.
# REQUIRES FIXING

echo "======================"
BROWSER=$(sed -n '2p' $WITCH/config.txt)
PROX=$(sed -n '3p' $WITCH/config.txt)
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
PACKAGEMGR=$(sed -n '4p' $WITCH/config.base.txt)
echo "Browser: $BROWSER"
echo "Proxy: $PROX"
echo "Package manager: $PACKAGEMGR"
echo "Distro name: $DISTRONAME"

METADISTRO=$(sed -n '2p' $WITCH/config.base.txt)
echo "Metadistro: $METADISTRO"
echo "======================"

if [ $LEARNIX_RUN == "true" ]; then
  SYSPATH=$LEARNIX/sys/$DISTRONAME
else
  SYSPATH=/mnt/$DISTRONAME
fi

function howdlpkg {
  echo
  $WITCH/color.sh QUESTION "how would you like to fetch your package manager"
  echo
  $WITCH/color.sh GREEN "
        A.    get it same way as in gentoo handbook (instructive)
        B.    enter a direct URL to the package manager (INCOMPLETE)
        C.    enter a location in the file system (already have downloaded)(INCOMPLETE)
  D.    already extracted"
  
  read Stage3dlmethod
  case $Stage3dlmethod in
    A|a)
      echo "$Stage3dlmethod was selected."
      sleep 1
      browserpkg
    ;;
    
    B|b)
      echo "$Stage3dlmethod was selected."
      sleep 4
      urlpkg
    ;;
    
    C|c)
      echo "$Stage3dlmethod was selected."
      sleep 4
      locpkg
    ;;
    
    D|d)
      echo "Proceeding..."
      sleep 2
    ;;
  esac
}

# as with stage download above, this needs to be put in a more automated and option-able method.  likely using "case - esac" or using earlier defined packagemanager choice.  ... so likely will warrant a refunctionising, creating a separate installportage and installpaludis, and... other?
# also, variablise it to be basedistro-savvy, so sensible defaults can be chosen, if ya like.
#read -p "that is as much as we can do for that now.  are you enjoying this so far?"
#[ "$REPLY" == "y" ] echo "well good then.  now we\'ll carry on getting your package manager too" && sleep 2

# Let's make this automated first, then we can unify it easily with case statements.

function browserpkg {
  echo "Now that the stage is installed, we continue to installing your package manager.  READ CAREFULLY:"
  sleep 2
  echo "Press y to use \" $BROWSER \" to navigate http://www.gentoo.org/main/en/mirrors2.xml to the snapshots directory in a mirror close to you.
  in /snapshots/, download the latest Portage snapshot (portage-latest.tar.bz2 NOT portage-latest.tar.xz) by selecting it and pressing D. When it finishes downloading, exit the browser by pressing q."
  #we'll add ability to use any format later.  or maybe ye who is reading this can. :P
  $WITCH/color.sh YELLOW "make sure it's in the $SYSPATH path"
  echo ""
  $WITCH/color.sh QUESTION "ready to download your portage (y - yes) (p - yes, with proxy support)"
  read
  
  case $REPLY in
    y|Y)
      $BROWSER http://www.gentoo.org/main/en/mirrors.xml
      $WITCH/color.sh QUESTION  "ready to continue? (y)"
      read REPLY
      if [ "$REPLY" == "y" ]; then
        echo "proceeding"
        echo "so what's your package manager filename? (e.g. portage-latest.tar.bz2)"
        read FILENAME
        if [ -f $SYSPATH/$FILENAME ]
        then
          echo "excellent you seem to have got your package manager downloaded successfully."
          extractpkg $SYSPATH/$FILENAME
        else
          echo "sorry, it didnt seem like you got a package manager then... er... wtf do we do now?  carry on n presume it\'s there?  give up and run away crying? try again?  well, it\'s up to you."
          sleep 2
          $WITCH/cauldren.sh
        fi
      fi
    ;;
    p|P)
      $BROWSER -http-proxy $PROX http://www.gentoo.org/main/en/mirrors.xml
      read -p "ready to continue? (y):"
      if [ "$REPLY" == "y" ]; then
        echo "proceeding"
        echo "so what's your package manager filename?"
        read FILENAME
        if [ -f $SYSPATH/$FILENAME ]; then
          echo "excellent you seem to have got your package manager downloaded successfully."
          sleep 2
          extractpkg $SYSPATH/$FILENAME
        else
          echo "sorry, it didnt seem like you got a package manager then... er... wtf do we do now?  carry on n presume it\'s there?  give up and run away crying? try again?  well, it\'s up to you."
          sleep 2
          $WITCH/cauldren.sh
        fi
      fi
    ;;
  esac
  
  #sort this bit out FIXME
  #md5sum -c portage-latest.tar.bz2.md5sum
}

function urlpkg {
  echo "where are you getting your package manager compressed-tarball from? what's the exact url?"
  read PKGURL
  cd $SYSPATH/usr
  wget $PKGURL
  extractpkg $PKGURL
}

function locpkg {
  echo "where is your package manager compressed-tarball located at? what's the exact file path adress?"
  read PKGLOC
  extractpkg $PKGLOC
}

function extractpkg {
  echo "unpacking your stage3 ($FILE) to $SYSPATH/usr/. this may take some time, please wait."
  echo "extracting $1 to $SYSPATH/usr/"
  tar xvf $1 -C $SYSPATH/usr
}

howdlpkg
