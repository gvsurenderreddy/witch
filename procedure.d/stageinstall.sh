echo "======================"
BROWSER=$(sed -n '2p' $WITCH/config.txt)
PROX=$(sed -n '3p' $WITCH/config.txt)
echo "Browser: $BROWSER"
echo "Proxy: $PROX"
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
ARCH=$(sed -n '3p' $WITCH/config.base.txt)
echo "Distroname: $DISTRONAME"
echo "Arch: $ARCH"
echo "======================"

if [ $LEARNIX_RUN == "true" ]; then
    SYSPATH=$LEARNIX/sys/$DISTRONAME
else
    SYSPATH=/mnt/$DISTRONAME
fi

#############
#############
# stageinstall
# Needs some changes. METADISTRO has been included for usage.

#copied from digit's witchnotes.
#change the browser bit.  at least extend the explanation, or re-word to something like, "download the .tar.bz2 stage3 file apropriate for your architechture, to $SYSPATH/" and then add a "are you ready to proceed? (have you got the stage3 in your distro-to-be's root dir?)" and perhaps even altering it, since i already have a check in place, change what happens upon that check failing, so that it gives the user time to arrange that to make sure it is there... perhaps even advising/educating on ways to do that (like explaining how with tty n wget or cp etc).

function howdlstage3 {
    echo 
    $WITCH/color.sh QUESTION "how would you like to fetch your stage3"
    echo 
    $WITCH/color.sh GREEN "
        A.    get it same way as in gentoo handbook (instructive)
        B.    enter a direct URL to the stage3 (INCOMPLETE)
        C.    enter a location in the file system (already have downloaded)(INCOMPLETE)
        D.    already extracted"

    read Stage3dlmethod
    case $Stage3dlmethod in
        A|a)
	    echo "$Stage3dlmethod was selected."
	    sleep 1
	    browserstage3
	    ;;
	    
        B|b)
	    echo "$Stage3dlmethod was selected."
	    sleep 4
	    urlstage3
	    ;;
	    
        C|c)
	    echo "$Stage3dlmethod was selected."
	    sleep 4
	    locstage3
	    ;;
	    
        D|d)
	    echo "Proceeding..."
	    sleep 2
	    ;;
    esac
}

function browserstage3 {
    echo "witchcraft will use browsers to download vital parts (and less vital parts too)"
    sleep 1
    echo "ok"
    sleep 1

    #get links n lynx variablised, so can then have either used throughout with ease (y'know, so like later on it'd be just $TXTBROWSER insteada links, and TXTBROWSER would be referenced to either links or lynx, like so: 
    #TXTBROWSER=hash links 2>&- || { echo >&2 "links is not installed.  how about lynx..."; lynx 1; }
    #echo "what is your prefered text webbrowser?" && read -r TXTBROWSER
    #   ... i think.  anyways, i'll not implement (uncomment) that just yet.  it'd mean making the appropriate changes bellow too.

    #variablise to denote any special needs per specific stages (such as the differences between exherbo and gentoo stages.)
    echo "READ INSTRUCTIONS CAREFULLY ~"	

    echo "here you need to extract a stage3 compressed tarball to $SYSPATH"
    echo "once you\'ve read these instructions, press y (and enter) to use \"$BROWSER\" web browser to navigate http://www.gentoo.org/main/en/mirrors2.xml to download your stage3 tarball for the base system."  
    echo ""
    echo "Once the page loads and you\'ve found a nearby mirror, navigate to the ** releases/$ARCH/autobuilds/ ** directory. There you should see all available stage files for your architecture (they might be stored within subdirectories named after the individual subarchitectures).  download the tar.bz2, not a tar.xz" #we'll add ability to use any format later.  or maybe ye who is reading this can. :P
    echo "If you're using a text browser: Select one and press D to download. Otherwise, download however you wish."
    echo ""
    echo "This may take some time. When it has finished, quit the browser (press q in links browser) (or just close the tab) and the rest of this script will resume."
    $WITCH/color.sh YELLOW "make sure it's in the $SYSPATH path."
    echo ""
    $WITCH/color.sh GREEN "ready to follow those instructions? (y - yes) (p - yes, with proxy support ~ may not work)"
    read

    # appears that to automate it
    # use netstat + wget
    # will do that in another option for downloading stage3.

    if [ "$REPLY" == "y" ]
    then
        $BROWSER http://www.gentoo.org/main/en/mirrors2.xml || $WITCH/color.sh ERROR "hmm things don't seem to have worked. open up your browser yourself, navigate to http://www.gentoo.org/main/en/mirrors2.xml and download to the witch directory at $SYSPATH"
        read -p "ready to continue? (y):" 

        if [ "$REPLY" == "y" ] 
        then 
            echo "proceeding" 
            echo "so what's your stage3 filename?"
            read FILENAME
            if [ -f $SYSPATH/$FILENAME ]
            then
                echo "excellent you seem to have got your stage3 downloaded successfully." 
                extractstage3 $SYSPATH/$FILENAME
            else
            	echo "looks like you didn't manage to download your stage3 successfully."
            	echo "in a couple of seconds we'll rerun this function."
            	sleep 3
            	browserstage3
            fi
        fi
    elif [ "$REPLY" == "p" ] 
    then
        $BROWSER -http-proxy $PROX http://www.gentoo.org/main/en/mirrors.xml || $WITCH/color.sh ERROR "hmm things don't seem to have worked. open up your browser yourself, navigate to http://www.gentoo.org/main/en/mirrors2.xml and download to the witch directory at $SYSPATH"
        read -p "ready to continue? (y):" 
        if [ "$REPLY" == "y" ]
        then
            echo "proceeding"
            echo "so what's your stage3 filename?"
            read FILENAME
            if [ -f $SYSPATH/$FILENAME ]
            then 
                echo "excellent you seem to have got your stage3 downloaded successfully."
                sleep 2
                extractstage3 $SYSPATH/$FILENAME
            else 
                echo "looks like you didn't manage to download your stage3 successfully."
            	echo "in a couple of seconds we'll rerun this function."
            	sleep 3
            	browserstage3
            fi 
        fi
    elif [ "$REPLY" == "n" ] 
    then 
        exit
    fi
}

function urlstage3 {
    echo "where are you getting your stage3 compressed-tarball from? what's the exact url?"
    read STAGE3URL
    cd $SYSPATH
    wget $STAGE3URL
    extractstage3 $STAGE3URL
}

function locstage3 {
    echo "where is your stage3 compressed-tarball located at? what's the exact file path adress?"
    read STAGE3LOC
    extractstage3 $STAGE3LOC
}

function extractstage3 {
    #set this so user can choose if they want verbose output
    echo "unpacking your stage3 ($FILE) to $SYSPATH. this may take some time, please wait."
    echo "extracting $1 to $SYSPATH"
    tar xvf $1 -C $SYSPATH
}

#script starts here.
sleep 1
echo

howdlstage3
