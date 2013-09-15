##########
##########
##########
##########
## bedrock - official installer

read -p "enter the name of your new distro: " DISTRONAME
echo $DISTRONAME > $WITCH/config.base.txt #1st line

METADISTRO=BEDROCK
echo $METADISTRO >> $WITCH/config.base.txt #2nd line

# Add ARCH and PACKAGEMGR!!!

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


#not sure if any of that^ is necessary for this method.

git clone https://github.com/paradigm/bedrocklinux-installer
cd bedrocklinux-installer
./bedrocklinux-installer
