echo "======================"
IBBROWSER=$(sed -n '5p' ./.config.txt)
PROX=$(sed -n '3p' ./.config.txt)
PACKAGEMGR=$1
DISTRONAME=$(sed -n '4p' ./.config.txt)
echo "(base) Browser: $IBROWSER"
echo "Proxy: $PROX"
echo "Package manager: $PACKAGEMGR"
echo "(base) Distro name: $DISTRONAME"
echo "======================"

# as with stage download above, this needs to be put in a more automated and option-able method.  likely using "case - esac" or using earlier defined packagemanager choice.  ... so likely will warrant a refunctionising, creating a separate installportage and installpaludis, and... other?
# also, variablise it to be basedistro-savvy, so sensible defaults can be chosen, if ya like.
#read -p "that is as much as we can do for that now.  are you enjoying this so far?"
#[ "$REPLY" == "y" ] echo "well good then.  now we\'ll carry on getting your package manager too" && sleep 2

echo "Now that the stage is installed, we continue to installing Portage, the package manager.  READ CAREFULLY:"
sleep 2
echo "Press y to use \" $IBROWSER \" to navigate http://www.gentoo.org/main/en/mirrors2.xml to the snapshots directory in a mirror close to you.
in the snapshots directory, download the latest Portage snapshot (portage-latest.tar.bz2) by selecting it and pressing D. When it finishes downloading, exit the browser by pressing q."
read -p "ready to download your portage (y - yes) (p - yes, with proxy support)"

if [ "$REPLY" == "y" ]
then 
    $IBROWSER http://www.gentoo.org/main/en/mirrors.xml 
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
    $IBROWSER -http-proxy $PROX http://www.gentoo.org/main/en/mirrors.xml 
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
echo "just uncompressing your $1 now, have a little wait."
tar -xjf /mnt/$DISTRONAME/$1-latest.tar.bz2 -C /mnt/$DISTRONAME/usr/

# /mnt/$DISTRONAME/usr/share/portage/config/make.conf # contains fully commented make.conf.
