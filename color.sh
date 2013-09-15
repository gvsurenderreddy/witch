# a board guy who loves colors.
Reset='\e[0m'
Red='\e[1;31m'
Green='\e[1;32m'
Yellow='\e[1;33m'

ERROR() {
  echo -e "[${Red}ERROR${Reset}] ${Yellow}$1${Reset}"
}

WARNING() {
  echo -e "[${Yellow}WARNING${Reset}] ${Green}$1${Reset}"
}

QUESTION() {
  echo -e "${Yellow}**${Reset} ${Green}$1${Reset} ${Yellow}**${Reset}"
}

RED() {
  echo -e "${Red}$1${Reset}"
}

GREEN() {
  echo -e "${Green}$1${Reset}"
}

YELLOW() {
  echo -e "${Yellow}$1${Reset}"
}

case "$1" in
  "ERROR") ERROR "$2" ;;
  "WARNING") WARNING "$2" ;;
  "QUESTION") QUESTION "$2" ;;
  "RED") RED "$2" ;;
  "GREEN") GREEN "$2" ;;
  "YELLOW") YELLOW "$2" ;;
esac
