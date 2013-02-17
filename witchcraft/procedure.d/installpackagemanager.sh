# Needs some changes. METADISTRO has been included for usage.
# REQUIRES FIXING

echo "======================"
BROWSER=$(sed -n '2p' $WITCH/config.txt)
PROX=$(sed -n '3p' $WITCH/config.txt)
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
PACKAGEMGR=$(sed -n '4p' $WITCH/config.base.txt)
echo "(base) Browser: $BROWSER"
echo "Proxy: $PROX"
echo "Package manager: $PACKAGEMGR"
echo "(base) Distro name: $DISTRONAME"

METADISTRO=$(sed -n '2p' $WITCH/config.base.txt)
echo "(base) Metadistro: $METADISTRO"
echo "======================"

function howdlpkg {
    echo 
    $WITCH/color.sh QUESTION "how would you like to fetch your package manager"
    echo 
    $WITCH/color.sh GREEN "
        A.    get it same way as in gentoo handbook (instructive)
        B.    enter a direct URL to the package manager (INCOMPLETE)
        C.    enter a location in the file system (already have downloaded)(INCOMPLETE)
        D.    dont want a package manager"

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
	    echo "what are you doing?"
	    sleep 2
	    clear
	    $WITCH/cauldren.sh
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
    $WITCH/color.sh YELLOW "make sure it's in the /mnt/$DISTRONAME path"
    echo ""
	$WITCH/color.sh GREEN "ready to download your portage (y - yes) (p - yes, with proxy support)"
    read
    
	if [ "$REPLY" == "y" ]
	then 
    	$BROWSER http://www.gentoo.org/main/en/mirrors.xml 
    	read -p "ready to continue? (y):" 
    	if [ "$REPLY" == "y" ] 
    	then
        	echo "proceeding" 
            echo "so what's your package manager filename?"
            read FILENAME
            if [ -f /mnt/$DISTRONAME/$FILENAME ]
            then
                echo "excellent you seem to have got your package manager downloaded successfully." 
                extractpkg $FILENAME
            else
                echo "sorry, it didnt seem like you got a package manager then... er... wtf do we do now?  carry on n presume it\'s there?  give up and run away crying? try again?  well, it\'s up to you." 
                sleep 2
                $WITCH/cauldren.sh
            fi
    	fi
	elif [ "$REPLY" == "p" ]
	then
    	$BROWSER -http-proxy $PROX http://www.gentoo.org/main/en/mirrors.xml 
    	read -p "ready to continue? (y):" 
   		if [ "$REPLY" == "y" ] 
   		then 
    	    echo "proceeding" 
            echo "so what's your package manager filename?"
            read FILENAME
            if [ -f /mnt/$DISTRONAME/$FILENAME ]
            then 
                echo "excellent you seem to have got your package manager downloaded successfully."
                sleep 2
                extractpkg $FILENAME
            else 
                echo "sorry, it didnt seem like you got a package manager then... er... wtf do we do now?  carry on n presume it\'s there?  give up and run away crying? try again?  well, it\'s up to you." 
                sleep 2
                $WITCH/cauldren.sh
            fi 
    	fi
	fi

	#sort this bit out FIXME
	#md5sum -c portage-latest.tar.bz2.md5sum
}

function urlpkg {
    echo "where are you getting your package manager compressed-tarball from? what's the exact url?"
    read $PKGURL
    cd /mnt/$DISTRONAME/usr
    wget $PKGURL
    extractpkg $PKGURL
}

function locpkg {
    echo "where is your package manager compressed-tarball located at? what's the exact file path adress?"
    read $PKGLOC
    extractpkg $PKGLOC
}

function extractpkg {
    # so let's do the dirty work for them.
    # they provided a URL/directory path for us.
    
    FILE=$(basename $1) # obtains the exact filename
    FILE_EXT='${FILE##*.}' # obtains the filename

    #set this so user can choose if they want verbose output
    echo "unpacking your stage3 ($FILE) to /mnt/$DISTRONAME/usr/. this may take some time, please wait."
    
    #ultra basic:
    echo "extracting $1 to /mnt/$DISTRONAME/usr/"
    
    case "$FILE_EXT" in
        tar.bz2) tar -xvjpf /mnt/$DISTRONAME/$FILE -C /mnt/$DISTRONAME/usr/ ;;
        tar.xz) tar -Jxvfp /mnt/$DISTRONAME/$FILE -C /mnt/$DISTRONAME/usr/ ;;
    esac

    # /mnt/$DISTRONAME/usr/share/portage/config/make.conf # contains fully commented make.conf.

    ###
    ### hacktown/
    ###

    #if $STAGE3LOC is-set then use $STAGE3LOC else use /stagewhatever.tar.whatever
    #perhaps set up a confirmation step, incase peeps have more than one stage3 downloaded... then they get directed to the locstage3 function
    #if tar.bz2 then xvjpf
    #if tar.xz then unxz && xvpf
    #if tar.gz then xvzpf

    ###
    ### /hacktown
    ###
}
