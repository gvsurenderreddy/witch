ERROR() {
    echo -e "[${Red}ERROR${Reset}] ${Yellow}$1${Reset}"
    exit 2
}

ERROR "$1"
