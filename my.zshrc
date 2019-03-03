
# HOW TO
# 1. Download a Powerline font (https://github.com/powerline/fonts) and set it as default
# 2. Install antigen: `mkdir ~/.antigen; curl -L git.io/antigen > ~/.antigen/antigen.zsh`
# 3. You could include this file with `source ~/scripts/my.zshrc` into your own config
# 4. Start zsh, packages will be installed during first run
# 5. fix compaudit errors with `sudo chmod -R 755 ~/.antigen`


# SETUP
# THEME="powerlevel9k" # options are "powerlevel9k" or "agnoster", can be set here or in your own config
source ~/.antigen/antigen.zsh


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


# PACKAGES
antigen use oh-my-zsh
antigen bundle zdharma/fast-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle colored-man-pages
antigen bundle akoenig/npm-run.plugin.zsh
antigen bundle arzzen/calc.plugin.zsh


# THEME
THEME=${THEME:-agnoster} # set default value

if [[ "$THEME" == "powerlevel9k" ]]; then
    # context
    DEFAULT_USER=$(whoami)
    POWERLEVEL9K_ALWAYS_SHOW_USER=true
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
    POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="cyan"
    POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="black"
    POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"

    # antigen theme bhilburn/powerlevel9k powerlevel9k
    antigen theme romkatv/powerlevel10k powerlevel10k
    antigen apply # placing of apply depends on theme
fi

if [[ "$THEME" == "agnoster" ]]; then
    antigen theme agnoster
    antigen apply # placing of apply depends on theme

    #DEFAULT_USER=$(whoami) # hide default user
    prompt_context() {
        # hide computer name (but show when connected to ssh)
        if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
            prompt_segment cyan black "%(!.%{%F{yellow}%}.)$USER"
        fi
    }

    prompt_dir() {
        # change colors
        prompt_segment blue white '%~'
    }
fi


# KEYBINDINGS
# Some bindings added by oh-my-zsh (https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/key-bindings.zsh)

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}"  end-of-line
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\eOH": beginning-of-line
bindkey "\eOF": end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

bindkey -M emacs '^[[3;5~' kill-word
bindkey -M emacs '^[[3^' kill-word
bindkey -M emacs '^H' backward-kill-word
# ctrl+backspace isn't possible, use ctr+w or alt+backspace


# ALIASES (`alias` for overview)

# - Abbreviations
alias l="ls -lhF"
alias la="ls -lhF --all"
alias g="git"
alias h="history -i | grep --color=always -E '  [0-9]+  ' | grep --color=always -E '[0-9]{2}:[0-9]{2}  ' | less +G"
alias c="clear"
alias rr='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# - Meta
alias colors='for i in {-1..255}; do if [[ "$i" < "0" ]]; then echo "Use like: \\\e[AA;5;XXm (AA = 38 (fore) | 48 (back), XX = 0 for reset, list below)"; else echo -en "\e[48;5;${i}m Color ${i}\e[0m \n"; fi; done | less'
alias reload="source ~/.zshrc"
unalias alias > /dev/null 2>&1
alias alias="alias | sed -e 's/^alias\\.//g' -e 's/=/ = /' | grep --color=always -E '^[^=]+=' | less -S -R"
