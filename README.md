Switch-user-env
=================================================

Unix script to load the environment of another unix user without making a call to the `su` command.  
Convenient when accessing a machine via a technical user to project into the environment of another user.

## Version actuelle : 1.0.0 ([CHANGELOG](CHANGELOG.md))

## Features:
- Change current $HOME (to make `cd` command without args redirect to target $HOME user)
- Load bash profile of target user (alias, prompt...)

## Usage:
    # Usage:  
        . ./switch_user_env.sh unix_user  
    # Args:  
        name of the unix user that must load the bash environment  
    # Help:  
        -h  display help
    # Code retour:  
        0   execution OK
        1   Error(s) occurs during execution
