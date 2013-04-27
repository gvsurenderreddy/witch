#! /bin/bash
#written by digit (+ the community).  most ambitious project yet. see http://github.com/Digit/witch for more

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
            echo "Choice was $WITCHCRAFTMODE. this part of the script is complete.  for full manual install, simply press ctrl-C at any time to enter fully manual mode. ;)"
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
export WITCH=$(pwd)

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
