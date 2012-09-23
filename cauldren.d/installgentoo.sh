##########
##########
##########
##########
### gentoo

METADISTRO=GENTOO
#for further revisions, there's sense in sort-of modularising this with even more functions, so each option can be called from a series of options.  make sense?  good.

#this doesnt need a comment.  it's self explanitory, surely.
ARCH="uname -m"

# will need to get this bit made paludis savvy, giving the user the choice, but for now, just telling it to be portage, will do.
PACKAGEMANAGERNAME=portage

###editor section to be improved
#EDITOR=mcedit
editorselect
echo "setting editor to $EDITOR " 
sleep 1
#EDITOR=hash mcedit 2>&- || { echo >&2 "mcedit is not installed.  how about nano..."; nano 1; }
#echo "what is your prefered text editor?" && read -r EDITOR

#get links n lynx variablised, so can then have either used throughout with ease (y'know, so like later on it'd be just $TXTBROWSER insteada links, and TXTBROWSER would be referenced to either links or lynx, like so: 
#TXTBROWSER=hash links 2>&- || { echo >&2 "links is not installed.  how about lynx..."; lynx 1; }
#echo "what is your prefered text webbrowser?" && read -r TXTBROWSER
#   ... i think.  anyways, i'll not implement (uncomment) that just yet.  it'd mean making the appropriate changes bellow too.

echo "so when you use your browser to find and select your stage, package manager, kernel, etc later on in this script, it will use your proxy, if you need it."
echo "will you need to use a http-proxy to access the web? (y)(if not sure, probably not):"
read REPLY
if [ "$REPLY" == "y" ] 
then
    echo "enter your proxy url (e.g.: proxy.server.com:8080)"
    read -r PROX
fi

#call the drive preparation function.
driveprep

#call the stage installation function
stageinstall

#call the package manager installation function
installpackagemanager

#call the function for initial configuration of make.conf
initialmakeconf

#call the preparation for chroot
prechroot

#call the wichroot
wichroot

#...and there we hit the end of the gentoo installation portion of witchcraft
#job done.  what's next... u want the deskfigselector() now dont you?
#good, cos it should already be lined up to run, thnx to the stage3 function (as a top level option from cauldren), which calls it straight after running the distroselector function.
#first you get run the witchcraft, thn you choose the cauldren, then you choose a proper stage3 install, then you get the distro, then you get the desktop.  ^_^  
#... is how this path rolls.  ^_^
