
# Settings

export HISTCONTROL=ignoredups:erasedups
export EDITOR=code
PROMPT_COMMAND='history -a'

# download theme

mkdir -p ~/.bash/themes/git_bash_windows_powerline 2>/dev/null
git clone https://github.com/diesire/git_bash_windows_powerline.git ~/.bash/themes/git_bash_windows_powerline 2>/dev/null
source ~/.bash/themes/git_bash_windows_powerline/theme.bash

# modify theme

USER_INFO_PROMPT_COLOR="C Bl"
CWD_PROMPT_COLOR="B W"
SCM_PROMPT_DIRTY_COLOR="Y Bl"
POWERLINE_LEFT_SEPARATOR="█ "
POWERLINE_PROMPT_CHAR="█"
SCM_PROMPT_DIRTY=" *"
SCM_PROMPT_AHEAD=" ↑"
SCM_PROMPT_BEHIND=" ↓"

# https://github.com/diesire/git_bash_windows_powerline/blob/master/theme.bash#L78
function __powerline_user_info_prompt {
  local user_info=""
  local color=${USER_INFO_PROMPT_COLOR}
  if [[ -n "${SSH_CLIENT}" ]]; then
    user_info="${USER_INFO_SSH_CHAR}\u@\h"
  else
    user_info=" \u" # Removed '@h' here
  fi
  [[ -n "${user_info}" ]] && echo "${user_info}|${color}"
}


# Aliasses

alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'
alias l='ls -lhF'
alias la="ls -lhF --all"
alias c='clear'
alias g='git' # more git aliasses in my.gitconfig
__git_complete g _git >/dev/null 2>&1

alias h="history | less +G"
alias y="yarn"
alias random='echo $RANDOM'
alias reload='source ~/.bashrc && clear'
hash() {
  echo $1 | md5sum
}

# adb
alias adbscreen='adb exec-out screencap -p > screen.png'
alias adbtunnel='adb reverse tcp:8081 tcp:8081 && adb reverse tcp:4000 tcp:4000 && adb reverse tcp:5000 tcp:5000'
alias adbclear='adb shell pm clear be.marlon.ar'
adbwireless() {
  adb tcpip 5555 && adb connect $1:5555
}
adblog() {
  adb -d logcat $1:ERROR *:S
}

# react native
alias rnrefresh='adb shell input text "RR"'
alias rnmenu='adb shell input keyevent 82'

# android emulator
alias emu='emulator.exe @Pixel_2_API_28'
alias emucold='emulator.exe @Pixel_2_API_28 -no-snapshot-load'

# docker
alias drem='docker rm $(docker ps -aq)'
alias dkill='docker kill $(docker ps -aq)'
alias dps='docker ps -a'
alias dup='docker-compose up'
alias ddown='docker-compose down'

# add colors
alias grep='grep --color=auto'
