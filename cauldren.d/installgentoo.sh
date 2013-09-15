##########
##########
##########
##########
### gentoo

## this section might be included in a seperate file.
read -p "enter the name of your new distro (anything you like - but keep it short and sweet): " DISTRONAME
echo $DISTRONAME > $WITCH/config.base.txt #1st line

METADISTRO=GENTOO #for further revisions, there's sense in sort-of modularising this with even more functions, so each option can be called from a series of options.  make sense?  good.
#ARCH="uname -m" #setting this bellow ~ remove if it's all good.

PACKAGEMGR=portage # will need to get this bit made paludis savvy, giving the user the choice, but for now, just telling it to be portage, will do.
#read -p "what is the name of the package manager you want? portage/paludis?" PACKAGEMGR
#echo $PACKAGEMGR was selected as the package manager you want to have installed
#^ but will leave that as the simple form until we've got some headway with paludis (and thus, likely once got some exherbo stuff working too

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

clear && $WITCH/procedure.d/driveprep.sh
clear && $WITCH/procedure.d/stageinstall.sh
clear && $WITCH/procedure.d/installpackagemanager.sh
clear && $WITCH/procedure.d/initialmakeconf.sh

# wichroot is only required for actual systems
# for Learnix systems it's not required.
if [ "$DIMG_RUN" == "true" ]; then
  echo "The creation of your system has finished."
else
  clear && $WITCH/procedure.d/prechroot.sh
  clear && $WITCH/procedure.d/wichroot.sh
fi
#...and there we hit the end of the gentoo installation portion of witchcraft
#job done.  what's next... u want the deskfigselector() now dont you?
#good, cos it should already be lined up to run, thnx to the stage3 function (as a top level option from cauldren), which calls it straight after running the distroselector function.
#first you get run the witchcraft, thn you choose the cauldren, then you choose a proper stage3 install, then you get the distro, then you get the desktop.  ^_^
#... is how this path rolls.  ^_^
