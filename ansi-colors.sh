# provide some variables to get colorful output

DARKGRAY='0;30'
RED='0;31'
BOLDRED='1;31'
GREEN='0;32'
BOLDGREEN='1;32'
YELLOW='0;33'
BOLDYELLOW='1;33'
BLUE='0;34'
BOLDBLUE='1;34'
PURPLE='0;35'
BOLDPURPLE='1;35'
CYAN='0;36'
WHITE='1;37'

echo_color() {
    # $1: the color
    # $2: the string
    echo -e "\e[${1}m${2}\e[0m"
}
