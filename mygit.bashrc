
# Settings

export HISTCONTROL=ignoredups:erasedups
export GREP_OPTIONS=' — color=auto'
export EDITOR=nano

# customize prompt
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]'  # set window title
PS1="$PS1"'\n'                          # new line
PS1="$PS1"'\[\033[32m\]'                # change to green
# PS1="$PS1"'\u@\h '                      # user@host<space>
PS1="$PS1"'\u '                         # user<space>
PS1="$PS1"'\[\033[35m\]'                # change to purple
# PS1="$PS1"'$MSYSTEM '                   # show MSYSTEM
PS1="$PS1"'\[\033[33m\]'                # change to brownish yellow
PS1="$PS1"'\w'                          # current working directory
PS1="$PS1"'\[\033[36m\]'                # change color to cyan
PS1="$PS1"'`__git_ps1`'                 # bash function
PS1="$PS1"'\[\033[0m\]'                 # change color
# PS1="$PS1"'\n'                          # new line
PS1="$PS1"' $ '                          # prompt: always $


# Aliasses

alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'
alias reload='source ~/.bashrc && clear'
alias c='clear'
alias l='ls -al'
alias g='git' # more git aliasses in my.gitconfig

# adb
alias adbscreen='adb exec-out screencap -p > screen.png'
alias adbtunnel='adb reverse tcp:8081 tcp:8081 && adb reverse tcp:4000 tcp:4000 && adb reverse tcp:5000 tcp:5000'
alias adbclear='adb shell pm clear be.marlon.ar'

# react native
alias rnrefresh='adb shell input text "RR"'
alias rnmenu='adb shell input keyevent 82'

# docker
alias drem='docker rm $(docker ps -aq)'
