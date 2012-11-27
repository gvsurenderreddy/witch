##########
# rowan
###(still just in emerge commands.)

echo "======================"
PACKAGEMGR=$(sed -n '4p' $WITCH/config.base.txt)
echo "PACKAGEMGR: $PACKAGEMGR"
echo "======================"

echo "you have chosen to install the rowan deskfig.  good choice.  is your nick Digit?"

case $PACKAGEMGR in
	portage) emerge -qv spectrwm yeahconsole tmux links mc mplayer rtorrent irssi htop bc ;;
	*) 
		echo "the package manager: $PACKAGEMGR is invalid for rowan. Redirecting you back..." 
		$WITCH/rewic.sh
	;;
esac

echo "sorry, the rest of the configuration of rowan has not yet been written into this script"
