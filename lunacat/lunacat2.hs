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
eval h "!willow" = privmsg h "willow, like rowan, but more flex."
eval h "!jamella" = privmsg h "jamella, showcase for tiling window managers."
eval h "!zelda" = privmsg h "zelda, pure vapor.  n not much of it"
eval h "!kali" = privmsg h "kali, pure vapor.  n not much of it"

eval h "!witches" = privmsg h "!rowan !willow !jamella"

eval h "!witch" = privmsg h "if she's the weight of a duck, then burn her!"
eval h "witch!" = privmsg h "BURN HER!"

eval h "!sites" = privmsg h "wa: http://tinyurl.com/witchlinux ... that links to mostly all the witch stuff out there... sorta."

eval h "!coc" = privmsg h "code of the covenant:  dont ask to ask, just ask.  dont ask to do, just do, then inform.  no flooding.  no spam.  no official. chat priority: witch > freedomware > anything else. if you are here, you are a witch developer now."

eval h "!bases" = privmsg h "it's witchcraft!  witches can be on any base!?  see !gentoo !funtoo !exherbo !debian !freebsd"

eval h "!gentoo" = privmsg h "gentoo based witches!?  yes! try out witchcraft."
eval h "!funtoo" = privmsg h "not yet. hack it up in witchcraft."
eval h "!exherbo" = privmsg h "not yet. hack it up in witchcraft."
eval h "!debian" = privmsg h "vm alpha2&3, and iso alpha4 of the rowan releases, are debian based.  also pre-alpha in witchcraft."
eval h "!freebsd" = privmsg h "not yet. hack it up in witchcraft."

eval h "!remaster" = privmsg h "not yet. hack it up in witchcraft. see https://github.com/Digit/witch/issues/5 for ways and to discuss ways"

-- eval h x | "!goog " `isPrefixOf` x = privmsg h (drop 4 x)
eval _   _                       = return () -- ignore everything else 

privmsg :: Handle -> String -> IO ()
privmsg h s = write h "PRIVMSG" (chan ++ " :" ++ s)



