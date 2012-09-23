##########
##########
##########
##########
## bedrock

METADISTRO=BEDROCK
# you are going to want to make extensive use of this link: http://opensource.osu.edu/~paradigm/bedrock/1.0alpha1/install.html ; for the making of this variable.
echo "sorry this part is just a place-holder so far.  please check out http://opensource.osu.edu/~paradigm/bedrock/ to garner some idea why digit is so keen to start to include bedrock ahead of funtoo and exherbo, and ahead of even getting the gentoo install completed."

echo
sleep 2
echo

echo "you may want to review http://opensource.osu.edu/~paradigm/bedrock/1.0alpha1/install.html#Partitioning before deciding how to partition"
driveprep
editorselect

echo "you may want to review \"http://opensource.osu.edu/~paradigm/bedrock/1.0alpha1/install.html#Creating the directory structure\" to see what's going on here."
echo "cd /mnt/$DISTRONAME"
cd /mnt/$DISTRONAME

echo "mkdir -p bin boot/extlinux dev etc/init.d home lib/modules opt/bedrock/bin opt/bedrock/sbin opt/bedrock/etc proc root sbin sys tmp usr/src var/lib/urandom"
mkdir -p bin boot/extlinux dev etc/init.d home lib/modules opt/bedrock/bin opt/bedrock/sbin opt/bedrock/etc proc root sbin sys tmp usr/src var/lib/urandom

echo "The default permissions on most of these should be fine. However, /tmp needs to be writable by no-root users:"
echo "chmod a+rwxt tmp"
chmod a+rwxt tmp

echo "you may want to review http://opensource.osu.edu/~paradigm/bedrock/1.0alpha1/install.html#Optional directories before answering this question:"
echo "do you want these optional directories?"
read -p "mkdir -p lib/firmware \#(y/n)?"
if [ "REPLY" == "y" ]
then 
    mkdir -p lib/firmware
    read -p "mkdir -p var/chroot \#(y/n/e)"

    if [ "REPLY" == "y" ] 
    then
        mkdir -p var/chroot

    elif [ "REPLY" == "e" ] 
    then
        echo "where would you like to put it then?" 
        read $BEDCHROOTS
        mkdir -p $BEDCHROOTS
    fi
fi

echo "you may want to review \"http://opensource.osu.edu/~paradigm/bedrock/1.0alpha1/install.html#Download core Bedrock Linux component sources\" for downloading of core components"

echo "i tried to warn you that this bedrock section was incomplete, now look what you've done... stuck where you left off.  ... that's ok though, just follow the last link it was suggested you may have wanted to review, and carry on from there.";
