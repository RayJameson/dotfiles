set -euo pipefail

function ask_user() {
    printf "$1 [y/n] "
    read answer < /dev/tty

    case $answer in
        y|Y|yes)
            return 0
            ;;
        n|N|no)
            return 1
            ;;
        *)
            echo "Unrecognized input"
            exit 1
            ;;
    esac
}
