#! /bin/bash
##########################################
##########################################
###################       wichroot       #
##########################################
##########################################

### variables assignment - will be rewritten into a new script and that script will be sent.
DISTRONAME=placeholder
PACKAGEMGR=placeholder
METADISTRO=placeholder
ROOTDEV=placeholder

### functions here to make life easier
install_pkg() { # put the packages to be installed as a string.

# so... what happens if the string is different? like in debian you install this but in gentoo you install that
# as a rule of thumb choose the most generic one, then add a if statement to check for the name and install what it's supposed to be
    case "$1" in
        "portage")
            echo "Installing package $2 ..."
            emerge $2
        ;;
        "dpkg")
            echo "Installing package $2 ..."
            aptitude install $2
        ;;
    esac
}

update_pkg() {
    case "$1" in
        "portage")
            echo "updating with \"emerge --sync\" not so quietly though.  may take several minutes..."
            emerge --sync
            echo "portage is now up to date." 
            sleep 1
            # add some savvy check to know if there's a new portage, n then have the script do, as the handbook says: If you are warned that a new Portage version is available and that you should update Portage, you should do it now using emerge --oneshot portage. 
        ;;

        "dpkg") # little example
            echo "updating with \"aptitude update\" not so quietly though. may take several minutes..."
            aptitude update
            echo "your system is now up to date"
            sleep 1
        ;;
    esac
}

echo "creating a new environment by essentially creating environment variables, then loading those variables into memory using source."
case "$METADISTRO" in
    "GENTOO")
        echo "env-update"
        env-update
    ;;
esac

echo "source /etc/profile"
source /etc/profile
echo "export PS1='\($DISTRONAME chroot\) \$PS1'"
export PS1="\($DISTRONAME chroot\) $PS1"
sleep 1

sleep 2 && clear

echo "making sure the $PACKAGEMGR tree of $DISTRONAME is up to date..."
echo
update_pkg 

sleep 2 && clear

#################################################################################
#this is the best work-around i've come up with yet to deal with passing the required variables to the chrooted environment.  it's not ideal, i know, and i'm certain there's a more elegant solution out there, but for now, this will have to do.
echo "since you're now well and truly in your newly chrooted environment, you need to set some variables again.  ~ this is an unfortunate kludge solution.  hack up, or put up. ~"
echo 
echo "what is your prefered text editor? (type the name of it\'s executable as exists on host system):" 
read CHEDITOR
export EDITOR="$CHEDITOR"
    
#mibi move it to before the portage sync'ing?
#################################################################################

sleep 2 && clear
gentoo_config() { ## GENTOO SPECIFIC
    #put profile selection into own function(s) too?  variablise and caseifthenesac it for the various bases and their variations (such as the number of profiles they offer)
    echo "First, a small definition is in place."
    sleep 1
    echo "A profile is a building block for any Gentoo system. Not only does it specify default values for USE, CFLAGS and other important variables, it also locks the system to a certain range of package versions. This is all maintained by the Gentoo developers.

Previously, such a profile was untouched by the users. However, there may be certain situations in which you may decide a profile change is necessary.

You can see what profile you are currently using (the one with an asterisk next to it)"
    echo "with eselect profile list:"
    sleep 1
    echo
    eselect profile list

    sleep 3
    echo
    echo "pick a number of profile you would like to switch to, if any, careful not to select a number that doesnt exist.  (type letter and hit enter)"
    echo "Choose a number from 1 to 15. The default is marked with an asterick."

    read PROFILESELECT

    echo "Choice was $PROFILESELECT. doing: eselect profile set $PROFILESELECT"
    sleep 1
    eselect profile set $PROFILESELECT

    echo "you can always try changing this later, using eselect."
}

case "$METADISTRO" in
    "GENTOO")
        gentoo_config
    ;;
esac

sleep 2 && clear

######start of chroot, i added a cheditor and chbrowser bit.  so this is redundant now... i hope, since i commented it out.
###editor section to be improved
#echo "incase your chrooted environment doesnt like your editor choice from your host os you can get a new one here."
#emerge -uqv nano
#CHEDITOR=nano #FIX ME augment that shit soon
#EDITOR=nano
#echo "setting editor to $EDITOR " && sleep 1

#######
#useflags section.
#######
#may decide to break this bit up and put in a seperate function() at some point perhaps.

useflags() {
    echo "you should have already made a make.conf file, and depending on what option you picked, and what you did, you may have already configured your USE flags, if you have not, not to worry, we can do that now, or even change them later."
    echo
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
    case "$REPLY" in 
        m) 
		    $EDITOR /etc/make.conf 
        ;;

        d) 
		    echo "looks like the make.conf default hasnt been made yet.  you will probably want to copy back from /etc/make.conf~rawvanillaoriginal or /usr/share/portage/config/make.conf or another from somewhere else, or make your own now, and maybe go to \#witchlinux on irc.freenode.net and tell digitteknohippie he forgot he left the make.conf section in such a state of disrepair."
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
}

useflags

sleep 2 && clear

locale_select() {
    #functionise these following bits too?  i presume they are all fairly universal, n not much (if any) variation between base distros.
    echo "You will probably only use one or maybe two locales on your system. You can specify locales you will need in /etc/locale.gen

e.g.

en_GB ISO-8859-1
en_GB.UTF-8 UTF-8
en_US ISO-8859-1
en_US.UTF-8 UTF-8

m - manually edit
d - dont care, do it for me, default it.  (warning, incomplete! overwrites!)
w - wget from _____ (warning this will overwrite existing locale.gen)
c - copy from _____ (warning this will overwrite existing locale.gen)
v - vanilla - dont touch it!  leave as is now."
    read REPLY
    case "$REPLY" in
	    m)
		    $EDITOR /etc/locale.gen
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
}

locale_select

sleep 2 && clear

kernel() {
    #presumably  put the kernel section in a variablised functionised chunk too?   could do with some clean up of what is pre-kernel-getting and what is actually kernel-getting
    echo "now you will likely need a kernel too"
    sleep 1
    echo "lets get your timezone sorted for that..."
    echo "Look for your timezone in /usr/share/zoneinfo, then we will copy it to /etc/localtime"
    sleep 2
    echo
    ls /usr/share/zoneinfo
    echo
    read -p "enter timezone (e.g. America, GMT): " TIMEZONE 

    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime

    echo "okay."
    sleep 2 && echo
    echo "The core around which all distributions are built is the Linux kernel. It is the layer between the user programs and your system hardware. Gentoo provides its users several possible kernel sources. A full listing with description is available at http://www.gentoo.org/doc/en/gentoo-kernel.xml "

    sleep 3
    #see previous comment.   kernel-getting.  
    #exherbo has taught us well here... let the user choose what kernel they want. 
    #grand expanding of this section, offering:
    #genkernel, debian kernels, hurd, freebsd, vanila kernel.org kernels, hurd+mach, hurd+l4, xenkernel, etc etc etc.
    # ....there-in we will see why digitteknohippie insist's it's called witch, before it's called witchlinux... the linux kernel need not even be present.  :)

    echo "so lets get on with getting you a kernel..."
    sleep 1
    # figure out a nice way to do this
    echo "how would you like to get a kernel?"
    case "$METADISTRO" in
        "GENTOO") echo "i - gentoo-sources and genkernel " ;;
        "DEBIAN") echo "i - debian repositories " ;;
    esac
    echo "m - manual (incomplete)"
    echo
    read -p "select which option: "
    case "$REPLY" in
        i) ## here you go. start making it seperate.
            case "$METADISTRO" in
            "GENTOO")
		        install_pkg $PACKAGEMGR "genkernel gentoo-sources"
		        genkernel --menuconfig all
		        # symlinking starts
		        ln -s /boot/kernel* /boot/vmlinuz
		        ln -s /boot/initramfs* /boot/initramfs.img
		    ;;
		    "DEBIAN") ## ask for kernel version since debian has different kernels
		    ## added as a proof of concept. fill it in later
		    ;;
		    esac
	    ;;

	    m) 
		    echo "woah there cowboy, how complete do you think this script is already!?  didnt we tell you this bit was incomplete.  ...you will have to sort that out entirely yourself later then.  http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=7#doc_chap3 might b handy"
	    ;;
    esac

    sleep 2
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
    
}

kernel

sleep 2 && clear

#put fstab section in it's own function
fstab() {
    echo "
_______What is fstab?

Under Linux, all partitions used by the system must be listed in /etc/fstab. This file contains the mount points of those partitions (where they are seen in the file system structure), how they should be mounted and with what special options (automatically or not, whether users can mount them or not, etc.)

_______Creating /etc/fstab

/etc/fstab uses a special syntax. Every line consists of six fields, separated by whitespace (space(s), tabs or a mixture). Each field has its own meaning:

The first field shows the partition described (the path to the device file). you can specify a UUID here too.
The second field shows the mount point at which the partition should be mounted
The third field shows the filesystem used by the partition
The fourth field shows the mount options used by mount when it wants to mount the partition. As every filesystem has its own mount options, you are encouraged to read the mount man page (man mount) for a full listing. Multiple mount options are comma-separated.
The fifth field is used by dump to determine if the partition needs to be dumped or not. You can generally leave this as 0 (zero).
The sixth field is used by fsck to determine the order in which filesystems should be checked if the system wasn not shut down properly. The root filesystem should have 1 while the rest should have 2 (or 0 if a filesystem check is not necessary).

---------------
so as you should already know, you configured your partitions some time ago. still remember them?

if not, open up another terminal and type in 'chroot /mnt/$DISTRONAME'.
Once you enter a new chroot environment type in 'sudo fdisk -l'

if yes, great!

"
    echo "so lets get on with setting up your fstab"
    sleep 1
    echo "how would you like to configure your fstab?
m - manual         (opens in editor)
s - skip           (manual later)
g - guided         (warning incomplete)
select which option:   "
    read
    case "$REPLY" in
	    m) 
		    echo "manual editing /etc/fstab selected" 
		    $EDITOR /etc/fstab
	    ;;

	    s) 
		    echo "skipping..."
	    ;;

	    g)
	        echo "silly sausage, this bit hasnt been made yet.  you can just sort out your fstab by yourself later.   fyi, this section will include a series of input choices for the various partitions/mounts."
	    ;;
    esac

    # FIXME ^ inset the fstab populator bit.  && add the variable-ised root, home n boot partitions... 
}

fstab

sleep 2 && clear

network() {
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
    sleep 2 && clear
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
    case "$REPLY" in
	    m)
		    echo "ok, to $EDITOR /etc/conf.d/hostname" 
		    $EDITOR /etc/conf.d/hostname
	    ;;

	    d) 
		    echo "witchgnubox" > /etc/conf.d/hostname
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
    
    sleep 2 && echo
    # edit this line, so that it finishes using $HOSTNOM.  would be easy if you just used last option only... but if insisting on the excessive version here, then we wikl need a clever extraction of $HOSTNOM from /etc/conf.d/hostname.  not important rly... so i am just commenting on this rather than getting it done, so it doesnt interupt my flow.
    echo "ok, so that should be your /etc/conf.d/hostname configured as it has your hostname."
    sleep 2 && echo
    # the /etc/conf.d/net is a far mroe elaborate config file than hpostname.  this is dangerously inadequate!  ... so i added the "RECCOMENDED"s, as well as the warnings already in place.
    echo "what do you want to do about your domain name (in /etc/conf.d/net)
m - RECOMMENDED: manually edit
d - dont care, do it for me, default it.  (adds ns_domain_lo=\"witchnet\")
w - wget from _____ (warning this will overwrite existing /etc/conf.d/net)
c - copy from _____ (warning this will overwrite existing /etc/conf.d/net)
v - RECOMMENDED: vanilla - dont touch it!  leave as is now.
e - enter network name now. (warning this will overwrite existing /etc/conf.d/net)"
    read REPLY
    case "$REPLY" in
	    m)
		    $EDITOR /etc/conf.d/net
	    ;;

	    d) 
		    echo "ns_domain_lo=\"witchnet\"" >> /etc/conf.d/net
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

    sleep 2 && echo

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
        echo
	    echo "ok.. " 
        sleep 2
	    echo "cd /etc/init.d" 
	    cd /etc/init.d 

	    echo "ln -s net.lo net.eth0"
	    ln -s net.lo net.eth0 

	    echo "this next bit is clever.  you should learn about rc-update.  a nice feature of gentoo." 
	    sleep 2
	    echo "rc-update add net.eth0 default" 
	    rc-update add net.eth0 default
    fi

    sleep 2 && echo

    echo "If you have several network interfaces, you need to create the appropriate net.eth1, net.eth2 etc. just like you did with net.eth0."
    echo 
    echo "now we inform linux about your network. in /etc/hosts"
    # FIXME obviously this needs work prior, as already commented on, to make sure these variables are set more cleanly and cleverly.
    echo "127.0.0.1 localhost" > /etc/hosts
    # see 2.9 / 2.10 for more elaborate stuff required to be set up here.  ... yes, /etc/hosts needs a more elaborate series of questions asked for it.
    echo "need to manually edit it? [y/n]"
    read
    if [ "$REPLY" == "y" ] 
    then
        $EDITOR /etc/hosts
    fi

    #PCMCIA section.
    echo "do you need PCMCIA? y/n:  "
    read
    if [ "$REPLY" == "y" ] 
    then
	    install_pkg $PACKAGEMGR pcmciautils
    fi
}

network

sleep 2 && clear

##############
#___######___#
####SYSTEM####
#___######___#
##############

# http://www.gentoo.org/doc/en/handbook/handbook-amd64.xml?part=1&chap=8#doc_chap2

echo "First we set the root password with \"passwd\""
passwd
echo "that should be your root password configured.  dont forget it, remember it."

sleep 2 && echo

echo "Gentoo uses /etc/rc.conf for general, system-wide configuration. Here comes /etc/rc.conf, enjoy all the comments in that file :) ... iz u ready for this? (y):" 
read REPLY
if [ "$REPLY" == "y" ]
then 
	$EDITOR /etc/rc.conf
fi

sleep 2 && clear

echo "hopefully you have got all you need, sorted in rc.conf.  if you changed your editor in rc.conf, this next bit should use it instead now."
sleep 1
echo "Gentoo uses /etc/conf.d/keymaps to handle keyboard configuration. Edit it to configure your keyboard."
sleep 2
echo "Take special care with the keymap variable. If you select the wrong keymap, you will get weird results when typing on your keyboard."
sleep 1
echo "-> do you need to change your keymap? [y/n]"
read
if [ "$REPLY" == "y" ] 
then
	$EDITOR etc/conf.d/keymaps
fi

sleep 2 && clear

echo "Gentoo uses /etc/conf.d/hwclock to set clock options. Edit it according to your needs. wanna change time? [y/n]"
read
if [ "$REPLY" == "y" ] 
then
	$EDITOR /etc/conf.d/hwclock
fi
# FIXME^ that was just barely a step past sheer lazy.

sleep 2 && clear
echo "so according to what you have got now, the date is:" && date 
sleep 3
echo "ok, so you should probably have your network, main config file (rc.conf), keyboard and clock configured.
now lets get tooled up with a system logger, command scheduler, and more file and network tools."
sleep 1

sleep 2 && clear

echo ""
echo "Installing Necessary System Tools"
sleep 1
#may want/need to variablise this, n have some checks of variables to know how to proceed for each base distros different stage3s
echo "Some tools are missing from the stage3 archive because several packages provide the same functionality. It is now up to you to choose which ones you want to install.

The first tool you need to decide on has to provide logging facilities for your system. Unix and Linux have an excellent history of logging capabilities -- if you want you can log everything that happens on your system in logfiles. This happens through the system logger.

Gentoo offers several system loggers to choose from. There are:
 - sysklogd, which is the traditional set of system logging daemons,
 - syslog-ng, an advanced system logger, 
and metalog which is a highly-configurable system logger. Others might be available through Portage as well - our number of available packages increases on a daily basis.

If you plan on using \"sysklogd\" or \"syslog-ng\" you might want to install \"logrotate\" afterwards as those system loggers do not provide any rotation mechanism for the log files.

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
		install_pkg $PACKAGEMGR syslogd 
		rc-update add syslogd default
    ;;

	b) 
		install_pkg $PACKAGEMGR syslog-ng 
		rc-update add syslog-ng default
	;;

	c)
		install_pkg $PACKAGEMGR metalog 
		rc-update add metalog default
	;;

	d)
		read -p "enter name of your choice of system logger: " SYSLOGA  
		install_pkg $PACKAGEMGR $SYSLOGA 
		rc-update add $SYSLOGA default   #add a sort of failsafe, so that if the emerge fails because no such package exists, user can then choose a,b,c,d or e again.  ~ yes, see this is an example where putting this into functions makes sense.  ...but i will carry on with this rudimentary version for now.
	;;
esac

sleep 2 && clear

#put crons into function(s) too
echo "now on to command schedulers, a.k.a. cron daemons."

echo "Although it is optional and not required for your system, it is wise to install one. But what is a cron daemon? A cron daemon executes scheduled commands. It is very handy if you need to execute some command regularly (for instance daily, weekly or monthly).

Gentoo offers three possible cron daemons: 
 - vixie-cron
 - dcron
 - fcron

If you do not know what to choose, use vixie-cron."

echo "which cron daemon do you want?
a. emerge vixie-cron && rc-update add vixie-cron default
b. emerge dcron && rc-update add dcron default && crontab /etc/crontab
c. emerge fcron && rc-update add fcron default && crontab /etc/crontab
d. enter name of other cron 
e. no cron (r u sure?)"
read
case "$REPLY" in
	a) 
		install_pkg $PACKAGEMGR vixie-cron 
		rc-update add vixie-cron default
    ;;

	b) 
		install_pkg $PACKAGEMGR dcron 
		rc-update add dcron default 
		crontab /etc/crontab
	;;

	c)
		install_pkg $PACKAGEMGR fcron 
		rc-update add fcron default 
		crontab /etc/crontab
	;;

	d) 
		read -p  "enter name of your choice of cron: " CRONNER 
		install_pkg $PACKAGEMGR $CRONNER
		rc-update add $CRONNER default
		crontab /etc/crontab   #add a sort of failsafe, so that if the emerge fails because no such package exists, user can then choose a,b,c,d or e again.  ~ yes, see this is an example where putting this into functions makes sense.  ...but i will carry on with this rudimentary version for now.
	;;
esac

sleep 2 && clear

#functionise
echo "If you want to index your files so you are able to quickly locate them using the locate tool, you need to install sys-apps/mlocate.
do you want locate? [y/n]"
read
if [ "$REPLY" == "y" ] 
then 
    install_pkg $PACKAGEMGR mlocate 
fi

sleep 2 && clear

#functionise
#re-write to add automation and other options?
echo "will you need dhcp or ppp?
d. dhcp
p. ppp
b. both
q. neither
"
read

case "$REPLY" in
    d) install_pkg $PACKAGEMGR dhcp ;;
    p) install_pkg $PACKAGEMGR ppp ;;
    b) install_pkg $PACKAGEMGR "dhcp ppp" ;;
esac

sleep 2 && clear

#oh rly, not even gonna give them a choice?  there is far more than just one.  :P  ;)  FIX ME... and functionise.   bootloader section could pretty much do with a whole rewrite.
#give them syslinux too. it's a nice bootloader. maybe lilo.
echo "Now that your kernel is configured and compiled and the necessary system configuration files are filled in correctly, it is time to install a program that will fire up your kernel when you start the system. Such a program is called a bootloader."
sleep 2
echo "so, do you want your bootloader to be on a current existing system? if not, we'll put the bootloader into your witch. [y/n]"
read REPLY

if [ $REPLY == "y" ]
then
    echo "okay."
    sleep 1
    echo "this section is still incomplete, sorry. hack it up :D"
    # chroot into the main drive (hackish method). then configure the current bootloader there.
    # for syslinux you need to install to the witch too.
    
    # and to make sure i don't forget
    # copy chain.c32 over to /boot/extlinux/
    # then type this out:
    # label witchname - metadistro
    # kernel /boot/extlinux/chain.c32
    # append hd0 1
    #  hd0 -> xth drive. like sda would be hd0, sdb would be hd1 and etc.
    #  1 -> partition 1. like /sda1 and /sdb1
    
    # that should clear things up.
    echo "i guess you should check out the file 'wichroot.sh' in 'procedure.d' and look at line 759 to 777 :D and figure out things on your own"
else
    echo "note, this section is just minimally done, very basic.  you will no doubt want to manually configure your boot loader properly.  here, we are just auto-populating it with a basic configuration which will most likely be unsuitable for anything but the most basic of partition configurations with a single boot (no \"dual boot\" or \"multi boot\"."
    echo "read more at http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=1&chap=10"
    
    echo "so which bootloader do you want?"
    echo "g - grub (grub grub grub)"
    echo "s - good old syslinux"
    read BOOTLOADER
    
    case $BOOTLOADER in
        g)
        echo "so you want grub."
        
        echo "installing grub in a moment. we'll install ncurses first."
        sleep 2
        install_pkg $PACKAGEMGR grub
        
        echo "a backup is created at /boot/grub/grub.conf.bk~"
        cp /boot/grub/grub.conf /boot/grub/grub.conf.bk~
        # note to self, find out a way to add incremental numberings to such copyings, so backups can be non-destructive.  you know like, ~if file exists then~
        echo "copied backup of any existing grub.conf to /boot/grub/grub.conf~origbkp"
        sleep 2
        echo "
        default 0
        timeout 30
        splashimage=(hd0,0)/boot/grub/splash.xpm.gz

        title=$DISTRONAME - $METADISTRO
        root (hd0,0)
        kernel /boot/kernel-2.6.12-gentoo-r10 root=/dev/ram0 init=/linuxrc ramdisk=8192 real_root=/dev/$ROOTDEV udev
        initrd /boot/initramfs-genkernel-amd64-2.6.12-gentoo-r10

        # Only in case you want to dual-boot
        title=Windows XP
        rootnoverify (hd0,5)
        makeactive
        chainloader +1" > /boot/grub/grub.conf
        ;;
    esac
fi

# tee that^ so the folks can see what you mean by:
sleep 1 
echo "as an interim kluge until you hack up something better, some crap has been thrown in your bootloader section. so you will want to find out what your kernel and initrd are called and what bootloader kernel options you want passed to it, and edit those in apropriately." 
sleep 2

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
