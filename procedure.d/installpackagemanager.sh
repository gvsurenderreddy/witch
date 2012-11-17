# Needs some changes. METADISTRO has been included for usage.

echo "======================"
BROWSER=$(sed -n '1p' ./config.txt)
PROX=$(sed -n '2p' ./config.txt)
DISTRONAME=$(sed -n '1p' ./config.base.txt)
PACKAGEMGR=$(sed -n '4p' ./config.base.txt)
echo "(base) Browser: $BROWSER"
echo "Proxy: $PROX"
echo "Package manager: $PACKAGEMGR"
echo "(base) Distro name: $DISTRONAME"

METADISTRO=$(sed -n '2p' ./.config.base.txt)
echo "(base) Metadistro: $METADISTRO"
echo "======================"

# as with stage download above, this needs to be put in a more automated and option-able method.  likely using "case - esac" or using earlier defined packagemanager choice.  ... so likely will warrant a refunctionising, creating a separate installportage and installpaludis, and... other?
# also, variablise it to be basedistro-savvy, so sensible defaults can be chosen, if ya like.
#read -p "that is as much as we can do for that now.  are you enjoying this so far?"
#[ "$REPLY" == "y" ] echo "well good then.  now we\'ll carry on getting your package manager too" && sleep 2

# Let's make this automated first, then we can unify it easily with case statements.

	echo "Now that the stage is installed, we continue to installing your package manager.  READ CAREFULLY:"
	sleep 2
	echo "Press y to use \" $BROWSER \" to navigate http://www.gentoo.org/main/en/mirrors2.xml to the snapshots directory in a mirror close to you.
in the snapshots directory, download the latest Portage snapshot (portage-latest.tar.bz2) by selecting it and pressing D. When it finishes downloading, exit the browser by pressing q."
	read -p "ready to download your portage (y - yes) (p - yes, with proxy support)"

	if [ "$REPLY" == "y" ]
	then 
    	$BROWSER http://www.gentoo.org/main/en/mirrors.xml 
    	read -p "ready to continue? (y):" 
    	if [ "$REPLY" == "y" ] 
    	then
        	echo "proceeding" 
        	if [ -f /mnt/$DISTRONAME/$PACKAGEMGR* ]
        	then 
            	echo "excellent you seem to have got your package manager ($1) gubbins downloaded successfully." 
        	else 
            	echo "sorry, it didnt seem like portage got downloaded correctly then.  something went wrong!  evade!  vamoose!  ...unless u know better"
        	fi
    	fi
	elif [ "$REPLY" == "p" ]
	then
    	$BROWSER -http-proxy $PROX http://www.gentoo.org/main/en/mirrors.xml 
    	read -p "ready to continue? (y):" 
   		if [ "$REPLY" == "y" ] 
   		then 
    	    echo "proceeding" 
    	    if [ -f /mnt/$DISTRONAME/$PACKAGEMGR* ] 
    	    then 
    	        echo "excellent you seem to have got your package manager ($1) gubbins downloaded successfully."
    	    else 
    	        echo "sorry, it didnt seem like ($1) got downloaded correctly then.  something went wrong!  evade!  vamoose!  ...unless u know better" 
    	    fi
    	fi
	fi

	#sort this bit out FIXME
	#md5sum -c portage-latest.tar.bz2.md5sum


	# this section will likely require tweaking when, as is mentioned in the previous comment, the package manager section get's put in it's own function (or series of functions rather)
	echo "just uncompressing your $PACKAGEMGR now, have a little wait."
	tar -xjf /mnt/$DISTRONAME/$PACKAGEMGR-latest.tar.bz2 -C /mnt/$DISTRONAME/usr/

	# /mnt/$DISTRONAME/usr/share/portage/config/make.conf # contains fully commented make.conf.

	#Unknown packages here.