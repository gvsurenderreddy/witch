##########
##########
##########
##########
### gentoo

## this section might be included in a seperate file.
read -p "enter the name of your new distro (anything you like - but keep it short and sweet): " DISTRONAME
echo $DISTRONAME > $WITCH/config.base.txt #1st line

METADISTRO=TINYCORE #for further revisions, there's sense in sort-of modularising this with even more functions, so each option can be called from a series of options.  make sense?  good.
#ARCH="uname -m" #setting this bellow ~ remove if it's all good.

PACKAGEMGR=portage # will need to get this bit made savvy to tinycore's 4-ways packagemanagement model... er... or do we?  maybe a couple of the ways ought be defined here?  idk... this is all getting sloppilly thrown in here for starters.  no idea how to do tinycopre, just know witch needs to do tinycore too.  ;)

#read -p "what is the name of the package manager you want? thisway/thatway?" PACKAGEMGR
#echo $PACKAGEMGR was selected as the package manager you want to have installed

echo $METADISTRO >> $WITCH/config.base.txt #2nd line
uname -m >> $WITCH/config.base.txt #3rd line
echo $PACKAGEMGR >> $WITCH/config.base.txt #4th line

echo "======================"
DISTRONAME=$(sed -n '1p' $WITCH/config.base.txt)
METADISTRO=$(sed -n '2p' $WITCH/config.base.txt)
ARCH=$(sed -n '3p' $WITCH/config.base.txt)
PACKAGEMGR=$(sed -n '4p' $WITCH/config.base.txt)
echo "DISTRONAME: $DISTRONAME"
echo "METADISTRO: $METADISTRO"
echo "ARCH: $ARCH"
echo "PACKAGEMGR: $PACKAGEMGR"
echo "======================"
sleep 1

clear && echo "WARNING, THIS IS JUST A STUB, IT WONT ACTUALLY INSTALL ANYTHING... YET  ... come join the hackup on #witchlinux on irc freenode net."
sleep 2
echo "have a look at: http://distro.ibiblio.org/tinycorelinux/install.html 
tinycore's install page.
"

#these lines of course would take one to the rest of the gentoo install... shall these scripts get broadened for use with any base distro, or will tinycore (and others) have to go their own way?
#clear && $WITCH/procedure.d/driveprep.sh
#clear && $WITCH/procedure.d/stageinstall.sh
#clear && $WITCH/procedure.d/installpackagemanager.sh
#clear && $WITCH/procedure.d/initialmakeconf.sh

#... i have no idea what wei2912 is on about with the learnix/diskimager thing...
# wichroot is only required for actual systems
# for Learnix systems it's not required.
if [ "$DIMG_RUN" == "true" ]; then
  echo "The creation of your system has finished."
else

#more old bits from the gentoo, which woulda been clearer if it didnt have this strange if^ thing happening.
#  clear && $WITCH/procedure.d/prechroot.sh
#  clear && $WITCH/procedure.d/wichroot.sh
fi

#...and there we hit the end of the tinycore installation portion of witchcraft
#job done.  what's next... u want the deskfigselector() now dont you?
#good, cos it should already be lined up to run, thnx to the stage3 function (as a top level option from cauldren), which calls it straight after running the distroselector function.
#first you get run the witchcraft, thn you choose the cauldren, then you choose a proper stage3 install, then you get the distro, then you get the desktop.  ^_^
#... is how this path rolls.  ^_^


###^^^ i know, it's all a mess.  one had to do it though.  one had to just grab the gentoo one and call it tinycore n amend as necessary.
