############
############
# wichroot
# Needs some changes. METADISTRO has been included for usage.
# Oh, and refactor it to make it easier to unify. Only some sections require change.

echo "======================"
DISTRONAME=$(sed -n '1p' ./.config.base.txt)
PACKAGEMGR=$(sed -n '4p' ./.config.base.txt)
echo "(base) Distro name: $DISTRONAME"
echo "PACKAGEMGR: $PACKAGEMGR"

METADISTRO=$(sed -n '2p' ./.config.base.txt)
echo "(base) Metadistro: $METADISTRO"
echo "======================"

################### wichroot likely needs an end bit to de-chroot, to make the rest of the script run. !!!!!!!!!!!!!!!!

echo "ENTER THE CHROOT" # http://www.linuxquestions.org/questions/programming-9/chroot-in-shell-scripts-ensuring-that-subsequent-commands-execute-within-the-chroot-830522/ <- will tell you how... at least the basics of it.  this still likely means packaging up the rest of the installer for the chrooted half, into a cat-eof'd && chmod+x'd script just prior to the chroot, and then running that.
sleep 1
cat > /mnt/$DISTRONAME/bin/witchroot <<CHEOF 
#! /bin/bash
##########################################
##########################################
###################       wichroot       #
##########################################
##########################################

echo "creating a new environment using env-update, which essentially creates environment variables, then loading those variables into memory using source."
echo "env-update"
env-update
echo "source /etc/profile"
source /etc/profile
echo "export PS1=\"($DISTRONAME chroot) $PS1\""
export PS1="($DISTRONAME chroot) $PS1"
sleep 1
echo "making sure the $PACKAGEMGR tree of $DISTRONAME is up to date with \"emerge --sync\" quietly.  may take several minutes..."

emerge --sync --quiet

echo "portage up to date." && sleep 1
# add some savvy check to know if there's a new portage, n then have the script do, as the handbook says: If you are warned that a new Portage version is available and that you should update Portage, you should do it now using emerge --oneshot portage. 

#################################################################################
#this is the best work-around i've come up with yet to deal with passing the required variables to the chrooted environment.  it's not ideal, i know, and i'm certain there's a more elegant solution out there, but for now, this will have to do.
echo "since you're now well and truly in your newly chrooted environment, you need to set some variables again.  ~ this is an unfortunate kludge solution.  hack up, or put up. ~"
echo 
cheditorselect() {
    echo "what is your prefered text editor? (type the name of it\'s executable as exists on host system):" 
    read CHEDITOR
}

chbrowserselect() {
    echo "what is your prefered web browser? (type the name of it\'s executable as exists on host system):"
    read CHBROWSER
}

cheditorselect
chbrowserselect
#mibi move it to before the portage sync'ing?
#################################################################################


#put profile selection into own function(s) too?  variablise and caseifthenesac it for the various bases and their variations (such as the number of profiles they offer)
echo "First, a small definition is in place.

A profile is a building block for any Gentoo system. Not only does it specify default values for USE, CFLAGS and other important variables, it also locks the system to a certain range of package versions. This is all maintained by the Gentoo developers.

Previously, such a profile was untouched by the users. However, there may be certain situations in which you may decide a profile change is necessary.

You can see what profile you are currently using (the one with an asterisk next to it)"
echo "eselect profile list"
eselect profile list

echo "pick a number of profile you would like to switch to, if any, careful not to select a number that doesnt exist.  (type letter and hit enter)"
echo "
    a=1, b=2, c=3, d=4, e=5, f=6, g=7, h=8, i=9, j=10, k=11, l=12, m=13, n=14, o=15"

read PROFILESELECT

case $PROFILESELECT in
        a)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 1"
                sleep 1
                eselect profile set 1
                ;;
        b)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 2"
                sleep 1
                eselect profile set 2
                ;;
        c)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 3"
                sleep 1
                eselect profile set 3
                ;;
        d)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 4"
                sleep 1
                eselect profile set 4
                ;;
        e)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 5"
                sleep 1
                eselect profile set 5
                ;;
        f)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 6"
                sleep 1
                eselect profile set 6
                ;;
        g)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 7"
                sleep 1
                eselect profile set 7
                ;;
        h)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 8"
                sleep 1
                eselect profile set 8
                ;;
        i)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 9"
                sleep 1
                eselect profile set 9
                ;;
        j)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 10"
                sleep 1
                eselect profile set 10
                ;;
        k)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 11"
                sleep 1
                eselect profile set 11
                ;;
        l)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 12"
                sleep 1
                eselect profile set 12
                ;;
        m)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 13"
                sleep 1
                eselect profile set 13
                ;;
        n)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 14"
                sleep 1
                eselect profile set 14
                ;;
        o)
                echo "Choice was $PROFILESELECT. doing: eselect profile set 15"
                sleep 1
                eselect profile set 15
                ;;
        *)
                echo "Valid Choices are a,b,c,d,e,f,g,,i,j,k,l,m,n,o, so you have gone wrong."
                exit 1
                ;;
esac

echo "you can always try changing this later, using eselect."

######start of chroot, i added a cheditor and chbrowser bit.  so this is redundant now... i hope, since i commented it out.
###editor section to be improved
#echo "incase your chrooted environment doesnt like your editor choice from your host os you can get a new one here."
#emerge -uqv nano
#CHEDITOR=nano #FIX ME augment that shit soon
#EDITOR=nano
#echo "setting editor to $CHEDITOR " && sleep 1

#######
#useflags section.
#######
#may decide to break this bit up and put in a seperate function() at some point perhaps.

echo "you should have already made a make.conf file, and depending on what option you picked, and what you did, you may have already configured your USE flags, if you have not, not to worry, we can do that now, or even change them later."
echo " 
showing you the /etc/make.conf in a moment" && sleep 1

echo "make sure the useflags look right (and then press q to continue once you have looked)"
sleep 5
less /etc/make.conf

echo "what would you like to do for your useflags in make.conf?"

echo "
m - manually edit
d - dont care, do it for me, default it.  (warning, incomplete! overwrites!)
w - wget from _____ (warning this will overwrite existing make.conf)
c - copy from _____ (warning this will overwrite existing make.conf)
v - vanilla - dont touch it!  leave as is now.
u - use the fully commented one from /mnt/$DISTRONAME/usr/share/portage/config/make.conf (warning, this will overwrite existing make.conf)
enter letter of preference: "
read REPLY
case $REPLY in 
    m) 
		$CHEDITOR /etc/make.conf 
    ;;

    d) 
		echo "looks like the make.conf default hasnt been made yet.  you will probably want to copy back from /etc/make.conf~rawvanillaoriginal or /usr/share/portage/config/make.conf or another from somewhere else, or make your own now, and maybe go to \#witchlinux on irc.freenode.net and tell digitteknohippie he forgot he left the make.conf section in such a state of disrepair." > /etc/make.conf 
	;;

	w) 
		echo "enter the url where your make.conf is located (e.g. http://pasterbin.com/dl.php?i=z5132942i ):" 
		read MAKECONFURL 
		wget $MAKECONFURL -o /etc/make.conf
	;;

	c)
		echo "enter the location where your make.conf is located (e.g. /usr/share/portage/config/make.conf):" 
		read MAKECONFLOC
		cp $MAKECONFLOC /etc/make.conf
	;;
	
	v)
		echo "well that is easily done.  ... done."
	;;

	u) 
		cp /usr/share/portage/config/make.conf /etc/make.conf 
	;;
esac

#FIXME ^ default

#functionise these following bits too?  i presume they are all fairly universal, n not much (if any) variation between base distros.
echo "You will probably only use one or maybe two locales on your system. You can specify locales you will need in /etc/locale.gen

e.g.

en_GB ISO-8859-1
en_GB.UTF-8 UTF-8
en_US ISO-8859-1
en_US.UTF-8 UTF-8

"
echo "
m - manually edit
d - dont care, do it for me, default it.  (warning, incomplete! overwrites!)
w - wget from _____ (warning this will overwrite existing locale.gen)
c - copy from _____ (warning this will overwrite existing locale.gen)
v - vanilla - dont touch it!  leave as is now.
"
read REPLY
case $REPLY in
	m)
		$CHEDITOR /etc/locale.gen
	;;

	d) 
		echo "looks like the locale.gen default hasnt been made yet.  you will probably want to go to #witchlinux on irc.freenode.net and tell digitteknohippie he forgot he left the locale.gen section in such a state of disrepair." >> /etc/locale.gen
	;;

	w) 
		echo "enter the url where your make.conf is located:" 
		read MAKECONFURL 
		wget $MAKECONFURL -o /etc/locale.gen
	;;

	c) 
		echo "enter the location where your make.conf is located (e.g. /usr/share/portage/config/make.conf):" 
		read MAKECONFLOC 
		cp $MAKECONFLOC /etc/locale.gen
	;;

	v)
		echo "well that is easily done.  ... done.  locale.gen as is."
	;;
esac

#consider changing to "locale-gen -a" ~ see man page, and try it out. or add that as an option above.
echo "now running locale-gen" && locale-gen
sleep 1

#presumably  put the kernel section in a variablised functionised chunk too?   could do with some clean up of what is pre-kernel-getting and what is actually kernel-getting
echo "now you will likely need a kernel too"
sleep 1
echo "lets get your timezone sorted for that...
 Look for your timezone in /usr/share/zoneinfo, then we will copy it to /etc/localtime"
sleep 2
read -p "enter timezone (e.g. GMT): " TIMEZONE 

cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime

echo "The core around which all distributions are built is the Linux kernel. It is the layer between the user programs and your system hardware. Gentoo provides its users several possible kernel sources. A full listing with description is available at http://www.gentoo.org/doc/en/gentoo-kernel.xml "

sleep 3
#see previous comment.   kernel-getting.  
#exherbo has taught us well here... let the user choose what kernel they want. 
#grand expanding of this section, offering:
#genkernel, debian kernels, hurd, freebsd, vanila kernel.org kernels, hurd+mach, hurd+l4, xenkernel, etc etc etc.
# ....there-in we will see why digitteknohippie insist's it's called witch, before it's called witchlinux... the linux kernel need not even be present.  :)

echo "so lets get on with getting you a kernel..."
sleep 1
echo "how would you like to get a kernel?
g - gentoo-sources and genkernel 
m - manual (incomplete)"
echo " "
read -p "select which option: "
case $REPLY in
	g) 
		emerge genkernel gentoo-sources
		genkernel all --menuconfig 
		ls /boot/kernel* /boot/initramfs* > /boot/kernelandinitinfo #FIXME
	;;

	m) 
		echo "woah there cowboy, how complete do you think this script is already!?  didnt we tell you this bit was incomplete.  ...you will have to sort that out entirely yourself later then.  http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=7#doc_chap3 might b handy"
	;;
esac

echo "- skipping kernel modules section, due to incompleteness.  see 7.e. Kernel Modules here: http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=7#doc_chap5 "

#echo "you might want kernel modules too right?"

# FIXME
#
#echo "To view all available modules"
#
#ls /boot/linux*
#find /lib/modules/$KERNV/ -type f -iname '*.o' -or -iname '*.ko' | less
### need to get the just compiled kernel name and version extracted cleanly, to be inserted there on $KERNV
# FIXME

#ls -l /usr/src/linux

#put fstab section in it's own function
echo "
_______What is fstab?

Under Linux, all partitions used by the system must be listed in /etc/fstab. This file contains the mount points of those partitions (where they are seen in the file system structure), how they should be mounted and with what special options (automatically or not, whether users can mount them or not, etc.)

_______Creating /etc/fstab

/etc/fstab uses a special syntax. Every line consists of six fields, separated by whitespace (space(s), tabs or a mixture). Each field has its own meaning:

The first field shows the partition described (the path to the device file)
The second field shows the mount point at which the partition should be mounted
The third field shows the filesystem used by the partition
The fourth field shows the mount options used by mount when it wants to mount the partition. As every filesystem has its own mount options, you are encouraged to read the mount man page (man mount) for a full listing. Multiple mount options are comma-separated.
The fifth field is used by dump to determine if the partition needs to be dumped or not. You can generally leave this as 0 (zero).
The sixth field is used by fsck to determine the order in which filesystems should be checked if the system wasn not shut down properly. The root filesystem should have 1 while the rest should have 2 (or 0 if a filesystem check is not necessary).
"
echo "so lets get on with setting up your fstab"
sleep 1
echo "how would you like to configure your fstab?
m - manual         (opens in editor)
s - skip           (manual later)
g - guided         (warning incomplete)
select which option:   "
read
case $REPLY in
	m) 
		echo "manual editing /etc/fstab selected" 
		$CHEDITOR /etc/fstab
	;;

	s) 
		echo "skipping..."
	;;

	g)
	echo "silly sausage, this bit hasnt been made yet.  you can just sort out your fstab by yourself later.   fyi, this section will include a series of input choices for the various partitions/mounts."
	;;
esac

# FIXME ^ inset the fstab populator bit.  && add the variable-ised root, home n boot partitions... 



####NETWORK#### mk1

# FIXME the whole network section could do with an overhaul and simplification and cleaning up.

###old first attempt at making the network section
###echo "whadya call this computer (what is your hostname)?
###- this will be set in /etc/conf.d/net"
###read NETNOM
###echo "dns_domain_lo=\"$NETNOM\"" >> /etc/conf.d/net
###
###echo "wanna use DHCP for connection? (if you dont know what that means, it is still likely you do)"
###echo "config_eth0=\"dhcp\"" >> /etc/conf.d/net

# FIXME ^ add NIS section, asking first if they want it, then follow the same a above, except of course, use >> instead of > for the /et/conf.d/net http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=8

# FIXME ^ change to a menu selection, allowing manual editing of hostname and net configs as an option, as well as "do it now" option, as above.

# FIXME ^ net'll likely need mending, since the host and net files 

###############
#___#######___#
####NETWORK####
#___#######___#
###############
############### mk2  (put network mk2 in own function.  network mk1 can probably be deleted now, right?
clear
echo "you will wanna be online too right?"

#this is probably excessive for just hostname, right?  and domain name bellow too...
echo "what do you want to do about your hostname (in /etc/conf.d/hostname)
m - manually edit
d - dont care, do it for me, default it.  (overwrites!)
w - wget from _____ (warning this will overwrite existing /etc/conf.d/hostname)
c - copy from _____ (warning this will overwrite existing /etc/conf.d/hostname)
v - vanilla - dont touch it.  leave as is now.
e - enter hostname now. (warning this will overwrite existing /etc/conf.d/hostname)"
read
case $REPLY in
	m)
		echo "ok, to $CHEDITOR /etc/conf.d/hostname" 
		$CHEDITOR /etc/conf.d/hostname
	;;

	d) 
		echo "witchgnubox" > /etc/conf.d/hostname #
	;;

	w) 
		echo "enter the url where your hostname filef is located (e.g. http://pasterbin.com/dl.php?i=z5132942i ):"
		read HOSTNOMURL 
		wget $HOSTNOMURL -o /etc/conf.d/hostname
	;;

	c) 
		echo "enter the location where your hostname file is located (e.g. /mnt/myexternal/myconfigbkpoverlay/etc/conf.d/hostname):" 
		read HOSTNOMLOC 
		cp $HOSTNOMLOC /etc/conf.d/hostname
	;;

	v) 
		echo "well that is easily done.  ... done."
	;;

	e) 
		read -p "whadya call this computer (what is your hostname)?
- this will be set in /etc/conf.d/hostname
ENTER HOSTNAME:" HOSTNOM 
		echo "hostname=$HOSTNOM " > /etc/conf.d/hostname
	;;
esac

# edit this line, so that it finishes using $HOSTNOM.  would be easy if you just used last option only... but if insisting on the excessive version here, then we wikl need a clever extraction of $HOSTNOM from /etc/conf.d/hostname.  not important rly... so i am just commenting on this rather than getting it done, so it doesnt interupt my flow.
echo "ok, so that should be your /etc/conf.d/hostname configured so it has your hostname."

# the /etc/conf.d/net is a far mroe elaborate config file than hpostname.  this is dangerously inadequate!  ... so i added the "RECCOMENDED"s, as well as the warnings already in place.
echo "what do you want to do about your domain name (in /etc/conf.d/net)
m - RECOMMENDED: manually edit
d - dont care, do it for me, default it.  (adds ns_domain_lo=\"witchnet\")
w - wget from _____ (warning this will overwrite existing /etc/conf.d/net)
c - copy from _____ (warning this will overwrite existing /etc/conf.d/net)
v - RECOMMENDED: vanilla - dont touch it!  leave as is now.
e - enter network name now. (warning this will overwrite existing /etc/conf.d/net)"
read REPLY
case $REPLY in
	m)
		$CHEDITOR /etc/conf.d/net
	;;

	d) 
		echo "ns_domain_lo=\"witchnet\"" >> /etc/conf.d/net #
	;;

	w) 
		echo "enter the url where your hostname file is located (e.g. http://pasterbin.com/dl.php?i=z5132942i ):" 
		read -r HOSTNOMURL 
		wget $HOSTNOMURL -o /etc/conf.d/net
	;;

	c) 
		echo "enter the location where your hostname file is located (e.g. /mnt/myexternal/myconfigbkpoverlay/etc/conf.d/net):"
		read HOSTNOMLOC
		cp $HOSTNOMLOC /etc/conf.d/net
	;;

	v) 
		echo "well that is easily done.  ... done."
	;;

	e) 
		echo "whadya call this network (what is your net)?
- this will be set in /etc/conf.d/net"
		read -p "ENTER DOMAIN NAME:" DOMNOM
		echo "ns_domain_lo=\"$DOMNOM\"" > /etc/conf.d/net
	;;
esac

echo "u wanna use dhcp right? y/n:  "
read REPLY
if [ "$REPLY" == "y" ] 
then
	echo "config_eth0=\"dhcp\"" >> /etc/conf.d/net
fi

echo "and u want to have networking activated at boot automatically for you, of course, right? y/n:  "
read REPLY
if [ "$REPLY" == "y" ] 
then
	echo "ok.. " 

	echo "cd /etc/init.d" 
	cd /etc/init.d 

	echo "ln -s net.lo net.eth0"
	ln -s net.lo net.eth0 

	echo "this next bit is clever.  you should learn about rc-update.  a nice feature of gentoo." 
	echo "rc-update add net.eth0 default" 
	rc-update add net.eth0 default
fi

echo "If you have several network interfaces, you need to create the appropriate net.eth1, net.eth2 etc. just like you did with net.eth0."

echo "now we inform linux about your network. in /etc/hosts"
# FIXME obviously this needs work prior, as already commented on, to make sure these variables are set more cleanly and cleverly.
echo "127.0.0.1     $HOSTNOM.$DOMNOM $HOSTNOM localhost" > /etc/hosts
# see 2.9 / 2.10 for more elaborate stuff required to be set up here.  ... yes, /etc/hosts needs a more elaborate series of questions asked for it.

#PCMCIA section.
echo "do you need PCMCIA? y/n:  "
read
if [ "$REPLY" == "y" ] 
then
	emerge pcmciautils
fi


##############
#___######___#
####SYSTEM####
#___######___#
##############

# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=8#doc_chap2

echo "First we set the root password with \"passwd\""
passwd
echo "that should be your root password configured.  dont forget it, remember it."

echo "Gentoo uses /etc/rc.conf for general, system-wide configuration. Here comes /etc/rc.conf, enjoy all the comments in that file :) ... iz u ready for this? (y):" 
sleep 2

read REPLY
if [ "$REPLY" == "y" ]
then 
	$CHEDITOR /etc/rc.conf
fi

clear
echo "hopefully you have got all you need, sorted in rc.conf.  if you changed your editor in rc.conf, this next bit should use it instead now."
sleep 1
echo "Gentoo uses /etc/conf.d/keymaps to handle keyboard configuration. Edit it to configure your keyboard."
sleep 1
echo "Take special care with the keymap variable. If you select the wrong keymap, you will get weird results when typing on your keyboard."
sleep 1
echo " do you need to change your keymap? "
read
if [ "$REPLY" == "y" ] 
then
	$CHEDITOR etc/conf.d/keymaps
fi

echo "Gentoo uses /etc/conf.d/hwclock to set clock options. Edit it according to your needs. wanna change time? "
read
if [ "$REPLY" == "y" ] 
then
	$CHEDITOR /etc/conf.d/hwclock
fi
# FIXME^ that was just barely a step past sheer lazy.

clear
echo "so according to what you have got now, the date is:" && date 
sleep 3
echo "ok, so you should probably have your network, main config file (rc.conf), keyboard and clock configured.
now lets get tooled up with a system logger, command scheduler, and more file and network tools."
sleep 1
echo ""
echo "Installing Necessary System Tools"
sleep 1
echo "system logger"
clear 
echo "system logger"
sleep 1
#may want/need to variablise this, n have some checks of variables to know how to proceed for each base distros different stage3s
echo "Some tools are missing from the stage3 archive because several packages provide the same functionality. It is now up to you to choose which ones you want to install.

The first tool you need to decide on has to provide logging facilities for your system. Unix and Linux have an excellent history of logging capabilities -- if you want you can log everything that happens on your system in logfiles. This happens through the system logger.

Gentoo offers several system loggers to choose from. There are:
sysklogd, which is the traditional set of system logging daemons,
syslog-ng, an advanced system logger, 
and metalog which is a highly-configurable system logger. Others might be available through Portage as well - our number of available packages increases on a daily basis.

If you plan on using sysklogd or syslog-ng you might want to install logrotate afterwards as those system loggers do not provide any rotation mechanism for the log files.

To install the system logger of your choice, emerge it and have it added to the default runlevel using rc-update.

choose a systemlogger to install and add to startup: "
sleep 1
echo "
a. emerge syslogd && rc-update add syslogd default
b. emerge syslog-ng && rc-update add syslog-ng default
c. emerge metalog && rc-update add metalog default
d. enter name of other system logger
e. no thnx (only if you are sure)


select a,b,c or d and press ENTER.
"
read REPLY
case $REPLY in
	a) 
		emerge syslogd 
		rc-update add syslogd default
	;;

	b) 
		emerge syslog-ng 
		rc-update add syslog-ng default
	;;

	c)
		emerge metalog 
		rc-update add metalog default
	;;

	d)
		read -p "enter name of your choice of system logger: " SYSLOGA  
		emerge $SYSLOGA 
		rc-update add $SYSLOGA default   #add a sort of failsafe, so that if the emerge fails because no such package exists, user can then choose a,b,c,d or e again.  ~ yes, see this is an example where putting this into functions makes sense.  ...but i will carry on with this rudimentary version for now.
	;;
esac

#put crons into function(s) too
clear
echo "now on to command schedulers, a.k.a. cron daemons."

echo "Although it is optional and not required for your system, it is wise to install one. But what is a cron daemon? A cron daemon executes scheduled commands. It is very handy if you need to execute some command regularly (for instance daily, weekly or monthly).

Gentoo offers three possible cron daemons: 
vixie-cron
dcron
fcron

If you do not know what to choose, use vixie-cron."

echo "which cron daemon do you want?
a. emerge vixie-cron && rc-update add vixie-cron default
b. emerge dcron && rc-update add dcron default && crontab /etc/crontab
c. emerge fcron && rc-update add fcron default && crontab /etc/crontab
d. enter name of other cron 
e. no cron (r u sure?)"
read
case $REPLY in
	a) 
		emerge vixie-cron 
		rc-update add vixie-cron default
	;;

	b) 
		emerge dcron 
		rc-update add dcron default 
		crontab /etc/crontab
	;;

	c)
		emerge fcron 
		rc-update add fcron default 
		crontab /etc/crontab
	;;

	d) 
		read -p  "enter name of your choice of cron: " CRONNER 
		emerge $CRONNER
		rc-update add $CRONNER default
		crontab /etc/crontab   #add a sort of failsafe, so that if the emerge fails because no such package exists, user can then choose a,b,c,d or e again.  ~ yes, see this is an example where putting this into functions makes sense.  ...but i will carry on with this rudimentary version for now.
	;;
esac

#functionise
echo "If you want to index your files so you are able to quickly locate them using the locate tool, you need to install sys-apps/mlocate.
do you want locate? (y)"
read
if [ "$REPLY" == "y" ] then emerge mlocate fi

#functionise
#re-write to add automation and other options?
echo "will you need dhcp or ppp?
d. dhcp
p. ppp
b. both
q. neither
"
read

if [ "$REPLY" == "d" ] then emerge phcpd fi
if [ "$REPLY" == "d" ] then emerge ppp fi
if [ "$REPLY" == "d" ] then emerge dhcp ppp fi

clear
sleep 1
echo "now for a scary bit..."
sleep 2
echo -n "boo!"
sleep 1
clear

#oh rly, not even gonna give them a choice?  there is far more than just one.  :P  ;)  FIX ME... and functionise.   bootloader section could pretty much do with a whole rewrite.
echo "Now that your kernel is configured and compiled and the necessary system configuration files are filled in correctly, it is time to install a program that will fire up your kernel when you start the system. Such a program is called a bootloader."
sleep 2
echo "installing grub"
emerge grub

clear
echo "note, this section is just minimally done, very basic.  you will no doubt want to manually configure your boot loader properly.  here, we are just auto-populating it with a basic configuration which will most likely be unsuitable for anything but the most basic of partition configurations with a single boot (no \"dual boot\" or \"multi boot\"."

cp /boot/grub/grub.conf /boot/grub/grub.conf~origbkp
# note to self, find out a way to add incremental numberings to such copyings, so backups can be non-destructive.  you know like, ~if file exists then~
echo "copied backup of any existing grub.conf to /boot/grub/grub.conf~origbkp" && sleep 2
echo "
default 0
timeout 30
splashimage=(hd0,0)/boot/grub/splash.xpm.gz

title=$DISTRONAME
root (hd0,0)
kernel /boot/kernel-2.6.12-gentoo-r10 root=/dev/ram0 init=/linuxrc ramdisk=8192 real_root=/dev/$ROOTDEV udev
initrd /boot/initramfs-genkernel-amd64-2.6.12-gentoo-r10

# Only in case you want to dual-boot
title=Windows XP
rootnoverify (hd0,5)
makeactive
chainloader +1" > /boot/grub/grub.conf

# tee that^ so the folks can see what you mean by:
sleep 1 && echo "as an interim kluge until you hack up something better, some crap has been thrown in your bootloader section. so you will want to find out what your kernel and initrd are called and what bootloader kernel options you want passed to it, and edit those in apropriately." && sleep 2

# ^ make a seditor to convert sda1 to (hd0,0) and so on. then use $ROOTDEV seditor'd to create GRUBDEV, and use $GRUBDEV in "root (hd0,0)" as "root $GRUBDEV" instead.
# use either something like uname -r or a clever ls /boot, to determine the kernel and define it as a variable (or use clever brackets n shiz) to use in place of initrd /boot/initramfs-genkernel-amd64-2.6.12-gentoo-r10
# yes basically i've done a cop-out for this section.  i am become lazyness.  lol.
# FIX ME ... FIX ME  ... FIX MEEEEE.   that boot section needs a serious re-work... lazy ass ....  wtf.

echo "job done. your base system is installed.  now lets make it a witch. :)"

#one very important final thought:
exit
# ;D  see, that was rather important, right?  ^_^

##########################################
##########################################
###################       wichroot       #
##########################################
##########################################
####       the wichroot fits into
####                 the here-CHEOF like i
####                 mentioned whenst echo
####                 "ENTER THE CHROOT" as
####                 this^^^ is just to be 
####                 able to use some more
####                 syntax highlighting!!
##########################################
########################################## ok. did that... shud b ok, from _cheof_ to _cheof_  ... but now, we need to get all the variables passed into the chroot system too.
##########################################  .... uhhh check the CHEOF (the chroot EOF "here" command)... isnt it missing something?
CHEOF

# && 
chmod +x /mnt/$DISTRONAME/bin/witchroot && echo "chroot /mnt/$DISTRONAME /bin/bash citchroot" && sleep 1 && chroot /mnt/$DISTRONAME /bin/bash witchroot

#warning! MAY WANT TO RE-TRIPLE-CHECK THAT^ since i moved the "here" command around a bit.  frankensteinings. did orgiginally have that line^ andand'd to the chroot directly.

#oops, left this part in there... dont want to enter the chroot twice!
#sleep 1
#echo "chroot /mnt/$DISTRONAME /bin/bash"
#chroot /mnt/$DISTRONAME /bin/bash
#^^^^^ end of witchroot function here?  or just before the chroot command?
#going for just after, for now.


#uhh... recheck that chrootage stuff... doesnt that look suspisciously like it's running chroot twice? yes, it was.  i think i sorted that now by commenting out that second one broken up over lines.  ... now srsly, we're gonna hafta clean up all this mucky excessive commenting.  oh well, at least it's keeping your head straight.

#or rather... need to get it so that the stuff in the CHEOFings, that gets put in witchroot script, gets initiated once you've chrooted...  but then, how do you tell it to execute that...   .... ah.   the issue remains. prolly better do as i said at the start of this chrootings, and get the gist of the basics from: http://www.linuxquestions.org/questions/programming-9/chroot-in-shell-scripts-ensuring-that-subsequent-commands-execute-within-the-chroot-830522/ and stop freaking out over it.
sleep 1
