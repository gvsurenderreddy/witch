import Network
import System.IO
import Text.Printf
import Data.List
import System.Exit
 
server = "irc.freenode.net"
port   = 6667
chan   = "#witchlinux"
nick   = "lunacat2"

main = do
    h <- connectTo server (PortNumber (fromIntegral port))
    hSetBuffering h NoBuffering
    write h "NICK" nick
    write h "USER" (nick++" 0 * :digitshaskellbot")
    write h "JOIN" chan
    listen h
 
write :: Handle -> String -> String -> IO ()
write h s t = do
    hPrintf h "%s %s\r\n" s t
    printf    "> %s %s\n" s t
 
listen :: Handle -> IO ()
listen h = forever $ do
    t <- hGetLine h
    let s = init t
    if ping s then pong s else eval h (clean s)
    putStrLn s
  where
    forever a = a >> forever a
 
    clean     = drop 1 . dropWhile (/= ':') . drop 1
 
    ping x    = "PING :" `isPrefixOf` x
    pong x    = write h "PONG" (':' : drop 6 x)
    
eval :: Handle -> String -> IO ()
eval h    "!quit"                = write h "QUIT" ":Exiting" >> exitWith ExitSuccess
--eval h x | Just x <- stripPrefix "!id " x = privmsg h x
--eval h (stripPrefix "!id " -> Just x) = privmsg h x
eval h x | "!id " `isPrefixOf` x = privmsg h (drop 4 x)
eval h "!search" = privmsg h "search yourself. :P"

--do simple command/response like this:
-- eval h "" = privmsg h ""
--command ^ and response ^

-- these are some basic sample commands for u to try out to make your own ones.
eval h "hello" = privmsg h "hello world"
eval h "!testcommand" = privmsg h "this is the test responce."

--info
eval h "!daskeb" = privmsg h "hello, i am daskeb, digit's haskell bot.  of course, i'm just a basic starter template.  you might want to look up http://www.haskell.org/haskellwiki/Roll_your_own_IRC_bot just for starters.  i came from half of that. i now have my own web presence at http://wastedartist.com/scripts/daskeb/daskeb.html"
eval h "!lunacat2" = privmsg h "hello, i am lunacat2.  lunacat died.  lunacat was a bot to help people with a sort of faq about witch, a gnu/linux opperating system distribution.  lunacat also contained info about lots more, mostly covered in digit's new bot called ema. to see some of my commands try !info"
eval h "!info" = privmsg h "!witches !sites !coc !bases !philosophy !who !remaster sorry i dont have many commands yet.  ~under construction~" 

--witches
eval h "!rowan" = privmsg h "rowan, wards away evil.  bloat is evil.  available to download as debian iso, also featured on arch, slackware and slitaz bases.  soon available in witchcraft"
eval h "!willow" = privmsg h "willow, like rowan, but more flex. vapourware/plan"
eval h "!jamella" = privmsg h "jamella, showcase for tiling window managers. vapourware/plan"
eval h "!zelda" = privmsg h "zelda, pure vapor.  n not much of it"
eval h "!kali" = privmsg h "kali, pure vapor.  n not much of it"
eval h "!eagle" = privmsg h "EAGLE Augments Grml with Lisp and Emacs."
eval h "!slackwitch" = privmsg h "unreleased rowan-like slackware based witches.  considered by digit as other alpha7 pre-releases during/after slitaz alpha7 pre-releases"
eval h "!mycowitch" = privmsg h "maybe there's some kind of bovine dermatology cream you can get for that.  or maybe it has something to do with fun guy.  vapourware."
eval h "!haylowitch" = privmsg h "haylo released a really nice minimal~!!! what, sorry i blinked, his pastebin expired, what was it ... anyone have a link?"
eval h "!wart" = privmsg h "valroadie is getting in on the action, and has wart witchos in the pipelines... more info to come."


--witches by metadistro  "creeds"  idk, need a better name for this.
eval h "!creeds" = privmsg h "creeds of witches of the following types have been found: !slitazwitch !slackwarewitch !debianwitch !gentoowitch !funtoowitch !archwitch !bedrockwitch"
eval h "!slitazwitch" = privmsg h "digit made some slitaz based witches, but didnt release them because he can be a fussy perfectionist at times."
eval h "!slackwarewitch" = privmsg h "digit made some slackware based witches, but didnt release them because he can be a fussy perfectionist at times."
eval h "!debianwitch" = privmsg h "digit released debian-rowan-witch alpha 2, 3 and 4 with a debian base."
eval h "!gentoowitch" = privmsg h "digit decided gentoo would be the first meta distro to include/complete in his witchcraft vision (a single installer/remastery tool that lets you decide your base system, and your distinct desktop environment configuration and app selection."
eval h "!funtoowitch" = privmsg h "digit thinks this will be the next meta-distro included in witchcraft's cauldren, but it could just as likely be debian, or bedrock, or dragora, or whatever."
eval h "!archwitch" = privmsg h "digit released a virtualbox arch rowan witch, alpha 5.  alpha 6 was historically considered, and legacy considered, a collective effort to create an archiso (or other remasterability means) version of arch witches... none was found easy nor convenient nor practical enough, and arch was put on the back burner, during a research period... at least for digit."
eval h "!slaxwitch" = privmsg h "we dont talk about that.  meow."
eval h "!bedrockwitch" = privmsg h "nothing much progressed, little beyond an initial starting stub in witchcraft... but come hack up the fun, or at least check out bedrock and learn how it is the biggest revolution since the GNU GPL. [statement may contain mild hyperbole]"


--knightnames
eval h "!knightnames" = privmsg h "!digit !him !orbea !jony !wgreenhouse !wei2912 !haylo"
eval h "!digit" = privmsg h "he who hath madeth the most, and founded and guided and whatnot, yet insists he's not the boss and anyone can make and release whatver they want with a witch stamp on it.  he who maketh the rowan, willow, jamella, slackwitch and others to come he says, yet no one has seen even a slackwitch but he, and neither willow nor jamella exist as anything but air."
eval h "!him" = privmsg h "he who nameth, and sparketh offeth this whole thing, and nameth himself so ye look illiterate."
eval h "!orbea" = privmsg h "he who is new to linux, but we always knew was leet.  fun guy with an itchy cow."
eval h "!jony" = privmsg h "he who hath made much, and is #1 witch user/developer... after digit and wei2912.  hath been around since the start."
eval h "!wgreenhouse" = privmsg h "he who art steady and wise.  he who maketh the eagle."
eval h "!wei2912" = privmsg h "he who hath come in late, but made great swathing changes and augments to witchcraft."
eval h "!theredmood" = privmsg h "he who has come far, but has far to go, and gets there at speed, sometimes."

--offlist knightnames
eval h "!lo9rd" = privmsg h "he who art a fleeting moogle.  a good luck charm/omen."
eval h "!haylo" = privmsg h "he who came, made an awesome ultra-light (as a duck) debian based core witch, at something like 60mb.  but did he post it anywhere that didnt expire, or in a sensible reccogniseable memorable name?  no.  ... anyone save it?..."
eval h "!gutterslob" = privmsg h "he who art a fleeting deity of configuration. keep tabs on what this one creates. it will make your eyes cry love from the solesof your feet."

-- who n groups n whats
eval h "!who" = privmsg h "see !knights !witches !villagers !creeds"
eval h "!villagers" = privmsg h "ye whom are chomping at the bit to call anything a witch and burn it. [to cd]"
eval h "!knights" = privmsg h "that's ye who determine if witches. see !knightnames"
eval h "!witches" = privmsg h "!rowan !willow !jamella !zelda !kali !eagle !slackwitch !haylo !mycowitch"

-- -- --
eval h "!witch" = privmsg h "if she's the weight of a duck, then burn her!    see !witches !bases !philosophy !who "
eval h "witch!" = privmsg h "BURN HER!"

--general about n stuff
eval h "!coc" = privmsg h "code of the covenant:  dont ask to ask, just ask.  dont ask to do, just do, then inform.  no flooding.  no spam.  no official. chat priority: witch > freedomware > anything else. if you are here, you are a witch developer now.  make whatever you want."

eval h "!history" = privmsg h "Him said to digit: you should make a distro called witch, so people could burn them [to cd].  that happened.  witch's philosophy since then is that anyone can make what they want, no central authority, office or hierachy.  it's a pure do-archy.  like wicca.  (but we're not actually witches/warlocks).  see !releasecron"
eval h "!releasecron" = privmsg h "slax-rowan-witch-alpha1, debian-rowan-witch-alpha2,3,4, arch-rowan-witch-alpha5,6, slitaz-rowan-witch-alpha7, slackwitch, witchcraft (aka alpha8, featuring ability to install gentoo-*-witch)"

eval h "!philosophy" = privmsg h "see !coc !witch !history"

eval h "!sites" = privmsg h "wa: http://tinyurl.com/witchlinux ... that links to mostly all the witch stuff out there... sorta.  puffinux and invariability and whatever else, they all sorta fell through, in one way or another."

--bases
eval h "!bases" = privmsg h "it's witchcraft!  witches can be on any base!?  see !gentoo !funtoo !exherbo !debian !freebsd !slackware !slitaz !bedrock (and try them with +witch, like !debianwitch)"
eval h "!gentoo" = privmsg h "gentoo based witches!?  yes! try out !witchcraft."
eval h "!funtoo" = privmsg h "not yet. hack it up in !witchcraft."
eval h "!exherbo" = privmsg h "not yet. hack it up in !witchcraft."
eval h "!debian" = privmsg h "vm alpha2&3, and iso alpha4 of the !rowan releases, are debian based.  also pre-alpha in !witchcraft, ready for you to help hack up."
eval h "!freebsd" = privmsg h "not yet. hack it up in !witchcraft."
eval h "!slackware" = privmsg h "unreleased alpha7s.  come hack it up in !witchcraft."
eval h "!slitaz" = privmsg h "unreleased alpha7s.  come hack it up in !witchcraft."
eval h "!bedrock" = privmsg h "barely begun to be slotted in, in !witchcraft.  come help hack it up."

--extras
eval h "!beards" = privmsg h "http://ompldr.org/vaTJzdw/beards3.png"
eval h "!ferretwitch" = privmsg h "http://bit.ly/Y4PHg4"

--witchcraft
eval h "!witchcraft" = privmsg h "an umbrella tool for all your witch installing, remastering, and witch sharing.  ~ in process of being written by digit and everyone else. come try out the code https://github.com/Digit/witch see also: !witchcraftidea !remastery !rewic !cauldren !witchhunt !rspm !witchcraftprogress and many more"
eval h "!beckon" = privmsg h "come try out the code https://github.com/Digit/witch and have a stab at hacking in your own sections of it, or fixing other bits. (please try to understand what other people are going for, and colaborate wisely, and remember forking is 100% as ok as teaming on one thing.  we can each have it our own way.)"

eval h "!witchcraftprogress" = privmsg h "witchcraft progress report [Sun Apr 14 00:17:09 BST 2013] (so far, gentoo base install works, some ground work for rowan witch done, and !rspm started, and !remastery up for dev discussion (spoilt for choice), and the sharing stuff is still just passing from vapour to pre-alpha)"

eval h "!witchcraftidea" = privmsg h "managing base meta-distros and package selection & desktop configuration as the two separate components that comprise your os. "

eval h "!remaster" = privmsg h "not yet. hack it up in witchcraft. see https://github.com/Digit/witch/issues/5 for ways and to discuss ways"

eval h "!rspm" = privmsg h "one package manager [wrapper] to rule them all.  just like pacman rosetta: https://wiki.archlinux.org/index.php/Pacman_Rosetta except in a wrapper script.  ... handy, for a distro that aims to allow any metadistro base.  https://github.com/Digit/witch/issues/18 will make further scripting easier."

eval h "!rewic" = privmsg h "stupid place-holder name for the witch remastery portion of witchcraft.  installation portion is called !cauldren, remaster portion is called !rewic.  https://github.com/Digit/witch/issues/18 we're spoiled for choice.  we just need to hack up."
eval h "!cauldren" = privmsg h "clever final name for the witch installer portion of witchcraft."
eval h "!witchhunt" = privmsg h "clever final name for the witch sharer/finder portion of witchcraft."

-- eval h x | "!goog " `isPrefixOf` x = privmsg h (drop 4 x)
eval _   _                       = return () -- ignore everything else 

privmsg :: Handle -> String -> IO ()
privmsg h s = write h "PRIVMSG" (chan ++ " :" ++ s)



