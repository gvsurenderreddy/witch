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

-- eval h "" = privmsg h ""


-- these are some basic sample commands for u to try out to make your own ones.
eval h "hello" = privmsg h "hello world"

eval h "!testcommand" = privmsg h "this is the test responce."

eval h "!daskeb" = privmsg h "hello, i am daskeb, digit's haskell bot.  of course, i'm just a basic starter template.  you might want to look up http://www.haskell.org/haskellwiki/Roll_your_own_IRC_bot just for starters.  i came from half of that. i now have my own web presence at http://wastedartist.com/scripts/daskeb/daskeb.html"

eval h "!lunacat2" = privmsg h "hello, i am lunacat2.  lunacat died.  lunacat was a bot to help people with a sort of faq about witch, a gnu/linux opperating system distribution.  lunacat also contained info about lots more, mostly covered in digit's new bot called ema. to see some of my commands try !info"

eval h "!info" = privmsg h "!witches !sites !coc !bases !remaster sorry i dont have many commands yet.  ~under construction~" 

eval h "!rowan" = privmsg h "rowan, wards away evil.  bloat is evil.  available to download as debian iso, also featured on arch, slackware and slitaz bases.  soon available in witchcraft"
eval h "!willow" = privmsg h "willow, like rowan, but more flex. vapourware/plan"
eval h "!jamella" = privmsg h "jamella, showcase for tiling window managers. vapourware/plan"
eval h "!zelda" = privmsg h "zelda, pure vapor.  n not much of it"
eval h "!kali" = privmsg h "kali, pure vapor.  n not much of it"
eval h "!eagle" = privmsg h "wgreenhouse's masterpiece lisp environment."
eval h "!slackwitch" = privmsg h "unreleased rowan-like slackware based witches.  considered by digit as other alpha7 pre-releases during/after slitaz alpha7 pre-releases"
eval h "!mycowitch" = privmsg h "maybe there's some kind of bovine dermatology cream you can get for that.  or maybe it has something to do with fun guy.  vapourware."

eval h "!slitazwitch" = privmsg h "digit made some slitaz based witches, but didnt release them because he can be a fussy perfectionist at times."
eval h "!slackwarewitch" = privmsg h "digit made some slackware based witches, but didnt release them because he can be a fussy perfectionist at times."
eval h "!debianwitch" = privmsg h "digit released debian-rowan-witch alpha 2, 3 and 4 with a debian base."
eval h "!gentoowitch" = privmsg h "digit decided gentoo would be the first meta distro to include/complete in his witchcraft vision (a single installer/remastery tool that lets you decide your base system, and your distinct desktop environment configuration and app selection."
eval h "!funtoowitch" = privmsg h "digit thinks this will be the next meta-distro included in witchcraft's cauldren, but it could just as likely be debian, or bedrock, or dragora, or whatever."
eval h "!archwitch" = privmsg h "digit released a virtualbox arch rowan witch, alpha 5.  alpha 6 was historically considered, and legacy considered, a collective effort to create an archiso (or other remasterability means) version of arch witches... none was found easy nor convenient nor practical enough, and arch was put on the back burner, during a research period... at least for digit."
eval h "!slaxwitch" = privmsg h "we dont talk about that.  meow."

eval h "!haylowitch" = privmsg h "haylo released a really nice minimal~!!! what, sorry i blinked, his pastebin expired, what was it ... anyone have a link?"

eval h "!villagers" = privmsg h "ye whom are chomping at the bit to call anything a witch and burn it. [to cd]"
eval h "!knights" = privmsg h "that's ye who determine if witches."
eval h "!witches" = privmsg h "!rowan !willow !jamella !zelda !kali !eagle !slackwitch !haylo !mycowitch"

eval h "!witch" = privmsg h "if she's the weight of a duck, then burn her!"
eval h "witch!" = privmsg h "BURN HER!"

eval h "!sites" = privmsg h "wa: http://tinyurl.com/witchlinux ... that links to mostly all the witch stuff out there... sorta.puffinux and invariability and whatever else, they all sorta fell through, in one way or another."

eval h "!coc" = privmsg h "code of the covenant:  dont ask to ask, just ask.  dont ask to do, just do, then inform.  no flooding.  no spam.  no official. chat priority: witch > freedomware > anything else. if you are here, you are a witch developer now.  make whatever you want."

eval h "!philosophy" = privmsg h "see !coc !witch !history"

eval h "!bases" = privmsg h "it's witchcraft!  witches can be on any base!?  see !gentoo !funtoo !exherbo !debian !freebsd !slackware !slitaz !bedrock (and try them with +witch, like !debianwitch)"

eval h "!gentoo" = privmsg h "gentoo based witches!?  yes! try out witchcraft."
eval h "!funtoo" = privmsg h "not yet. hack it up in witchcraft."
eval h "!exherbo" = privmsg h "not yet. hack it up in witchcraft."
eval h "!debian" = privmsg h "vm alpha2&3, and iso alpha4 of the rowan releases, are debian based.  also pre-alpha in witchcraft, ready for you to help hack up."
eval h "!freebsd" = privmsg h "not yet. hack it up in witchcraft."
eval h "!slackware" = privmsg h "unreleased alpha7s.  come hack it up in witchcraft."
eval h "!slitaz" = privmsg h "unreleased alpha7s.  come hack it up in witchcraft."
eval h "!bedrock" = privmsg h "barely begun to be slotted in, in witchcraft.  come help hack it up."

eval h "!remaster" = privmsg h "not yet. hack it up in witchcraft. see https://github.com/Digit/witch/issues/5 for ways and to discuss ways"

-- eval h x | "!goog " `isPrefixOf` x = privmsg h (drop 4 x)
eval _   _                       = return () -- ignore everything else 

privmsg :: Handle -> String -> IO ()
privmsg h s = write h "PRIVMSG" (chan ++ " :" ++ s)



