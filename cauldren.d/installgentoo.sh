##########
##########
##########
##########
### gentoo

## this section might be included in a seperate file.
read -p "enter the name of your new distro: " DISTRONAME
echo $DISTRONAME > ./config.base.txt #1st line

METADISTRO=GENTOO #for further revisions, there's sense in sort-of modularising this with even more functions, so each option can be called from a series of options.  make sense?  good.
ARCH="uname -m"
PACKAGEMGR=portage # will need to get this bit made paludis savvy, giving the user the choice, but for now, just telling it to be portage, will do.

echo $METADISTRO >> ./config.base.txt #2nd line
echo $ARCH >> ./config.base.txt #3rd line
echo $PACKAGEMGR >> ./config.base.txt #4th line

echo "======================"
DISTRONAME=$(sed -n '1p' ./config.base.txt)
METADISTRO=$(sed -n '2p' ./config.base.txt)
ARCH=$(sed -n '3p' ./config.base.txt)
PACKAGEMGR=$(sed -n '4p' ./config.base.txt)
echo "DISTRONAME: $DISTRONAME"
echo "METADISTRO: $METADISTRO"
echo "ARCH: $ARCH"
echo "PACKAGEMGR: $PACKAGEMGR"
echo "======================"
sleep 1
#EDITOR=hash mcedit 2>&- || { echo >&2 "mcedit is not installed.  how about nano..."; nano 1; }
#echo "what is your prefered text editor?" && read -r EDITOR

#get links n lynx variablised, so can then have either used throughout with ease (y'know, so like later on it'd be just $TXTBROWSER insteada links, and TXTBROWSER would be referenced to either links or lynx, like so: 
#TXTBROWSER=hash links 2>&- || { echo >&2 "links is not installed.  how about lynx..."; lynx 1; }
#echo "what is your prefered text webbrowser?" && read -r TXTBROWSER
#   ... i think.  anyways, i'll not implement (uncomment) that just yet.  it'd mean making the appropriate changes bellow too.

#call the drive preparation function.
clear && ./utilities.d/driveprep.sh

#call the stage installation function
clear && ./procedure.d/stageinstall.sh

#call the package manager installation function
clear && ./procedure.d/installpackagemanager.sh

#call the function for initial configuration of make.conf
clear && ./procedure.d/initialmakeconf.sh

#call the preparation for chroot
clear && ./procedure.d/prechroot.sh

#call the wichroot
clear && ./procedure.d/wichroot.sh

#...and there we hit the end of the gentoo installation portion of witchcraft
#job done.  what's next... u want the deskfigselector() now dont you?
#good, cos it should already be lined up to run, thnx to the stage3 function (as a top level option from cauldren), which calls it straight after running the distroselector function.
#first you get run the witchcraft, thn you choose the cauldren, then you choose a proper stage3 install, then you get the distro, then you get the desktop.  ^_^  
#... is how this path rolls.  ^_^  	
