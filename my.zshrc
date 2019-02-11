
# HOW TO
# 1. Install antigen: `mkdir ~/.antigen; curl -L git.io/antigen > ~/.antigen/antigen.zsh`
# 2. You could include this file with `source /path/to/my.zshrc` into your own config
# 3. Start zsh, packages will be installed during first run
# 4. fix `compaudit` errors with `sudo chmod -R 755 ~/.antigen`

# SETUP

source ~/.antigen/antigen.zsh
antigen use oh-my-zsh

# - Setup theme
THEME=agnoster
antigen list | grep $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi # allows reloading config

# - Install packages
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle colored-man-pages
antigen bundle akoenig/npm-run.plugin.zsh
antigen bundle arzzen/calc.plugin.zsh
antigen apply

# SETTINGS
setopt auto_pushd # make cd push old dir in dir stack
setopt pushd_ignore_dups # no duplicates in dir stack
setopt inc_append_history # Add commands to history as they are entered, don't wait for shell to exit
setopt hist_ignore_all_dups # Do not keep duplicate commands in history
setopt bang_hist # !keyword
setopt share_history # share hist between sessions
setopt auto_cd # if command is a path, cd into it

unsetopt beep # no bell on error
unsetopt list_beep # no bell on ambiguous completion

export SAVEHIST=1000
export HISTSIZE=1000

# KEYBINDINGS
# Some bindings added by oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/key-bindings.zsh)

bindkey -M emacs '^[[3;5~' kill-word
bindkey -M emacs '^[[3^' kill-word
bindkey -M emacs '^H' backward-kill-word
# ctrl+backspace isn't possible, use ctr+w or alt+backspace


# ALIASES (`alias` for overview)

# - Abbreviations
alias l="ls -lhF"
alias la="ls -lhF --all"
alias g="git"
alias h="history | grep --color=always -E '[0-9]+ ' | less +G"

# - Meta
alias reload="source ~/.zshrc" > /dev/null 2>&1 # TODO: doesn't really work well, better just exit and zsh
unalias alias > /dev/null 2>&1
alias alias="alias | sed -e 's/^alias\\.//g' -e 's/=/ = /' | grep --color=always -E '^[^=]+=' | less -S -R"
