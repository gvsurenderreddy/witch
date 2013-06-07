##########
##########
##########
##########
#### rewic
##########
##########
##########
##########

#insert rewic here, once it's sorted out

# NOTE! this function in the script WAS (now removed) a franken-disection-hackage gutted from tazlitoforwitchcraftextractions, which is just a copy of the earliest tazlito to have write-iso included.  it still needs much re-reading n hackage to get to work, especially across all gentoo-esq (and other) distros.    ... so i just completely removed it for now.  i think it was 1.3... er... or 2.1  or..   sometime around there it got the writeiso feature.
#all tazlito changed to rewic, and all slitaz changed to witch.  ;)  just so you know.

###  let the hacking commence!
#removed... ...devomer#

#might wanna consider nabbing some ideas from debian-live-helper and the linux-live scripts famed from the slackers.  
#but tazlito's remasterer is rather the tits, so if we could get it to work instead, it'd be... " the tits "
function rewicwitchhunt {
echo "ADD STUFF HERE, SCRIPT INCOMPLETE.  STUB. here we go hunting for pre-made isos.  more witches to burn!"
witchhunt.sh
}
function rewicdd {
echo "enter the input ... jk, THIS PORTION INCOMPLETE.  STUB.  here we just dd'up wherever you choose, to wherever you choose."
}

function rewicmenu {

echo "how u wanna do this?"

echo "
    A.    dd (use with caution)
    B.    tar (with exclude list if you want)
    C.    linux-live scripts
    D.    tazlito
    E.    
    D.    enter your own preference of remaster manager"

read REWICMETHOD

case $REWICMETHOD in
        A|a)
                echo "Choice was $REWICMETHOD.  dd"
                rewicdd
                ;;
        B|b)
	        echo "Choice was $REWICMETHOD.  tar"
                sleep 1
                rewictar
                ;;
        C|c)
	        echo "Choice was $REWICMETHOD.  linux live"
                sleep 1
                rewiclinuxlive
                ;;
        D|d)
	        echo "Choice was $REWICMETHOD.  tazlito"
                sleep 1
                rewic
                ;;
# was gonna add mores... but i'm lazy... and it's not like any are implemented yet.
        E|e)
	        echo "ok, taking you to find one we made earlier... let the witch hunt commence."
                sleep 1
                rewicwitchhunt
                ;;       
        F|f)
	        echo "going back"
                sleep 1
                rewic
                ;;
}


function rewic {
    echo "rewic, the iso remastery stuff has been gutted from this version while we work out the installer stuff ~ no loss it didnt work yet anyway." 

    echo "we strongly urge you to have a look through https://github.com/Digit/witch/issues/5 and in particular, the links in the first comment, which are a collection of resources to point the ways we could go about remastering." 

rewicmenu
}

rewic
