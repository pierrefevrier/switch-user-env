#!/bin/echo This script should be executed by source: .
##################################################################
# @(#) $Id: switch_user_env.sh $
##################################################################
# Versions :
#  1.0.0 [31/01/2016]
#   First working release
##################################################################

##################################################################
# FONCTIONS
##################################################################

# Fonction usage()
# description : Display help for this script
# in    :
# out   : 
function usage {
    echo "Help of switch_user_env.sh"
    echo "Description :"
    echo "  Switch current shell in bash environment of another user"
    echo "Version :"
    echo "  1.0"
    echo "Usage :"
    echo "  . switch_user_env.sh unix_user"
    echo "Args :"
    echo "  name of the unix user that must load the bash environment"
    echo "Help:"
    echo "  -h	display help"
    echo "Return code :"
    echo "  0 : execution OK"
    echo "  1 : Error(s) occurs during execution"
}

##################################################################
# CHECK SCRIPT ARGS
##################################################################

# Reset script index args (http://stackoverflow.com/questions/23581368/bug-in-parsing-args-with-getopts-in-bash#23615586)
OPTIND=1

# Parsing script args
while getopts ":h" opt; do
	case $opt in
        h)
            usage
            return 0
            ;;
        :)
            echo "ERROR - Arg $OPTARG need a value." >&2
            usage
            return 1
            ;;
		\?) 
            echo "ERROR - Invalid option: -$OPTARG." >&2
            usage
            return 1
            ;;
  	esac
done

# Take care vars we use are not already set
unset TARGET_USER

# Read args not parsed by getopts

shift $(( OPTIND - 1 ))

for opt in "$@"; do
    # Check: only one user expected
    if [ "$TARGET_USER" != "" ]; then
        echo "ERROR - Only one user is expected." >&2
        usage
        return 1
    else
        TARGET_USER="$opt"
    fi
done

# Clean temp vars/functions to do not pollute parent shell which source this script
unset opt

# Technical control of mandatory args

if [ "$TARGET_USER" == "" ]; then
    echo "ERROR - One user is expected."
    usage
    return 1
fi

# Functionnal control of mandatory args

# User exists ?
if [ ! -d "/usr/users/$TARGET_USER" ]; then
    echo "ERROR - Unix user $TARGET_USER doesn't exist in /usr/users/$TARGET_USER"
    return 1
fi

# Clean temp vars/functions to do not pollute parent shell which source this script
unset usage

##################################################################
# BEGIN TREATMENT
##################################################################

# 
# Change current HOME
#

HOME="/usr/users/$TARGET_USER"
cd "$HOME"

# Clean temp vars/functions to do not pollute parent shell which source this script
unset TARGET_USER


#
# Choice startup script to call when init bash (cf http://unix.stackexchange.com/questions/258499/change-unix-user-environment/258506)
# See https://www.gnu.org/software/bash/manual/bash.txt (6.2 Bash Startup Files) for bash startup script order
#

if [ -f "$HOME/.bash_profile" ]; then
        RC_FILE="$HOME/.bash_profile"
elif [ -f "$HOME/.bash_login" ]; then
        RC_FILE="$HOME/.bash_login"
elif [ -f "$HOME/.profile" ]; then
        RC_FILE="$HOME/.profile"
fi

#
# Start new bash shell
#

if [ "$RC_FILE" == "" ]; then
        bash
else
        bash --rcfile "$RC_FILE"
fi

# Clean temp vars/functions to do not pollute parent shell which source this script
unset RC_FILE
