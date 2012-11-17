#! /bin/bash
#written by digit.  most ambitious project yet. see http://github.com/Digit/witch for more

#refactorise branch

#latest development plan. along with re-functionising more chunks, make a function menu from which install processes etc, can be accessed non-linearly, and include at all apropriate multi-choice questions, an option to return to this navigational index function map.  easy, savy.  one function to rule all functions, as n when the user wants... and, more to the imediately pertinent reason, so that testing it isnt such a pain in the hoooooop!  ... half an hour to get through to check for the bugs near the end.  gah.

# re-laying out witchcraft2011 with functions http://mywiki.wooledge.org/BashGuide/CompoundCommands#Functions 
#(think of functions like variables, that can contain huge chunks of code, easily, without getting into silly chains of && && &&.)

clear #neatness freak

### dont be bothered if the comments seem outta wack, they are.  ...need to go clean that up some more still.
# will remove this guff when the comments n shiz r cleaned up of those redundant or irelevent or outdated or just guff...

#version (probably gonna keep version as "concept v0.00" until it's at least ready for a trial run.
echo "VERSION: gentoo install test v0.00 " #oldversion#echo "VERSION: concept v0.00"
echo "(means dont try to run it yet, for the sake of your computer.  retreat while you can.)"

##dev-intro
#for sake of navigation, check out the functions: rewic, cauldren (and it's functions), distroselector, deskfigselector.  they're all launched in a tree of options, starting at the end of this script, after all the functions have been defined.
echo 

#intro
sleep 1
echo "Hi, \"$USER\"."
sleep 1
echo "welcome to the latest incarnation of the witchcraft script."
sleep 1

#the plan for this script is as a wrapper for the various commands required for building a gentoo/funtoo/exherbo/witch, offering preset options to choose from, and a final option offering the ability to input your own commands or data.

#for example, when selecting kernel, preset options of a handfull of kernels may be offered, 1. the latest stable from kernel.org, 2. gentoo sources, 3. zen kernel, 4. enter your own url
#for example, for partition locations, select location for / root dir, 1. /dev/sda1, 2. enter own location
#for examples, when selecting stage3, when selecting boot options, even offering the option to make an iso of the existing system.
# just to give you an idea.


#for consideration of future addition to the script: metro

#
#to be completed
#gentoo install
#other installs too*
#remastery (tazlito hackage... or: 
#and loads of little bites here n there

#* other installs inc (in one plausible order of construction) : funtoo, exherbo, arch, slitaz, crux, sabayon, hadron, freebsd, openbsd, dragonflybsd, stali


##########################################
##########################################
# DEVNOTE 
#prechroot and whichroot
# prechroot is put in it's own function.  that's nice.
# wichroot however...  
# here's the problem, as it is, it wont work.  why?  the variables already set, wont exist in the chrooted environment.
# suggestions for how to get around this...
#    write variables to a file, then they'll be available from within the chrooted environment too... not quite sure how to then get them into action as variables set in the script.  might write them out to a script to be run in this one, or write it to the wichroot cheof script that runs the chroot bit (no that's insane).
#    somehow directly pipe them into action again in this script, without having to write a file... somehow.
#    
# besides all that... aught the CHEOF also get cunked into variables too?
#
#
# here's an idea....writeable chunks, so that the CHEOF it'self gets broken up, likely into lots of little CHEOFF addendums, not just into variables.   such an idea... i might branch again to try that, n then merge back into refunctionise branch, before completing all the refunctionising, 



#echo "what do you want your witch based on? (warning options are incomplete)"
#select SPINTOP in \
#    'VanillaBase (no gui desktop)' \
#    'rowan (anti-bloat tiling lightweight) ' \
#    'willow (like rowan, but more lax on bloat, for comfort)' \
#    'jamella (tiling wm showcase)' \
#    'select own desktop&applications set (enter link to script)' \
#    'semi-manual suggestion list' \
#    'full manual (like VanillaBase, but able to write a command)' \
#    'other  (idfk)' \
#do
#    case $REPLY in #or is that $REPLY sposa b $SPINTOP, no?  it baulked errors like that.
#        1 ) echo "ok, doing nothing here then, as is, bare $BASE" ;;
#        2 ) echo "good choice, a minimal but complete & useable desktop configuration."
#            echo "INSERT ROWAN SET INSTALLATION HERE emerges and configurations";;
#        3 ) echo "good choice, a lightweight but complete & useable desktop configuration." 
#            echo "INSERT WILLOW APP INSTALLATION HERE emerges and configurations";;
#        4 ) echo "good choice, a showcase of all tiling window managers... " 
#            echo "INSERT TILING WM INSTALLATION HERE emerges and configurations"
#            echo "INSERT TILING WM (non-repo)SOURCE INSTALLATIONS OPTION HERE and configurations"
#            echo "INSERT OPTION TO INSTALL ROWAN OR WILLOW OTHER APPS TOO emerges and configurations";;
#        5 ) echo "INSERT INSTRUCTIONS AND \"read\" USER INPUT PROMPT FOR LOCATION OF OWN INSTALL SCRIPT" ;;
#        6 ) echo "INSERT APP GROUP BY APP GROUP APPLICATION MULTIPLE CHOICE" ;;
#        7 ) echo "INSERT ABILITY TO ENTER ONE COMMAND (OR STRING OF COMMANDS) TO INSTALL DESIRED APPLICATIONS" ;;
#        8 ) echo "and idk what would go here, this is still just a dummy mock up while laying it all out." ;;
#        * ) print 'invalid.' ;;
#    esac ; 
#    if [[ -n $SPINTOP ]]; then
#        echo "you have selected \"$SPINTOP\""
#        break
#    fi
#done

# FIXME ^ 

questions() {
    # your native directory
    echo "Your native directory is... $WITCH"

    $WITCH/color.sh QUESTION "what is your prefered text editor? (type the name of it's executable as exists on host system):" 
    read EDITOR 
    echo $EDITOR > $WITCH/config.txt #1st line

    $WITCH/color.sh QUESTION "what is your prefered web browser? (type the name of it's executable as exists on host system):" 
    read BROWSER 
    echo $BROWSER >> $WITCH/config.txt #2nd line

    $WITCH/color.sh QUESTION "so... you need a proxy? you might want to stay hidden :P just press enter if you don't know what i am talking about or you don't need one" 
    read PROX 
    echo $PROX >> $WITCH/config.txt #3rd line

    $WITCH/color.sh QUESTION "finally are you an ub0r l33t? [y/n] we give ub0r l33ts the supreme choice to intervene (not yet implemeneted :P)"
    read INTERVENE
    echo $INTERVENE >> $WITCH/config.txt #4th line
}

menu() {
    clear
	$WITCH/color.sh QUESTION "what do you want to do?"
	$WITCH/color.sh GREEN "
    A.    write iso of current operating system (rewic)
    B.    install a new operating system (cauldren)
    C.    do it all yourself
    Q.    quit because you don't want to listen to us anymore"

	read WITCHCRAFTMODE

	case $WITCHCRAFTMODE in
		A|a)
            echo "Choice was $WITCHCRAFTMODE. sorry, this part of the script is still under construction.  running it in a couple seconds anyway"
            sleep 5
            $WITCH/rewic.sh
            ;;
		B|b)
            echo "Choice was $WITCHCRAFTMODE. sorry, this part of the script is still under construction.  running it in a couple seconds anyway"
            sleep 5
            $WITCH/cauldren.sh
            ;;
		C|c) 
            echo "Choice was $WITCHCRAFTMODE. this part of the script is complete.  for full manual install, simply press ctrl-C at any time to enter fully manual mode."
            echo "exiting to full manual mode now"
            exit
            ;;
		Q|q) 
            exit
            ;;
		*)
            $WITCH/color.sh RED "Valid Choices are A,B,C. Don't press Q. Please."
			sleep 5
			menu
            ;;
	esac
}

echo ""

### time to set up a nice little environmental variable
pushd `dirname $0` > /dev/null
export WITCH=`pwd`
popd > /dev/null

#root check
if [[ $EUID -ne 0 ]]
then
    $WITCH/color.sh RED "Hmm, you don't have any root. Poor you."
    $WITCH/color.sh ERROR "go back and get root. before you come back."
    exit 1
else
    $WITCH/color.sh RED "And you've passed thy root test! You may continue..."
    sleep 3
fi

echo
questions
menu
