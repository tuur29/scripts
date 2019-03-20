export HISTCONTROL=ignoredups
export GREP_OPTIONS=' — color=auto'
export EDITOR=nano

alias ..='cd ..'


alias reload='source ~/.bashrc'
alias c='clear'
alias l='ls -al'

# git aliasses in my.gitconfig
alias g='git'

# adb
alias adbscreen='adb exec-out screencap -p > screen.png'
alias adbtunnel='adb reverse tcp:8081 tcp:8081 && adb reverse tcp:4000 tcp:4000 && adb reverse tcp:5000 tcp:5000'
alias adbclear='adb shell pm clear be.marlon.ar'

# react native
alias rnrefresh='adb shell input text "RR"'
alias rnmenu='adb shell input keyevent 82'


# docker
alias drem='docker rm $(docker ps -aq)'
