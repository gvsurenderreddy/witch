echo "Extracting ${1}..."

filename=$(basename "$1")
extension="${filename#*.}"

case $extension in
    "tar.bz2") tar -xvjf $1 ;;
    "tar.gz") tar -zxvf $1 ;;
esac
