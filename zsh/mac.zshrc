# ~/.zshrc - macOS, with Starship

########## Homebrew ##########
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

########## Zsh Options ##########
setopt autocd
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst

WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=""

########## Keybindings ##########
bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line

bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

########## Command Completion ##########
# Homebrew's zsh completions (must be added to fpath before compinit)
if [ -n "$HOMEBREW_PREFIX" ]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

autoload -Uz compinit
compinit -d ~/.cache/zcompdump

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,time,command'

########## History ##########
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify

alias history="history 0"

########## `time` Command Output ##########
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

########## Aliases ##########

# lsd (brew install lsd)
if command -v lsd &>/dev/null; then
    alias ls='lsd'
    alias ll='lsd -l'
    alias lt='lsd -l --tree'
    alias lat='lsd -la --tree'
    alias l='lsd -F'
    alias la='lsd -AF'
    alias lah='lsd -lAF'
    alias tt='lsd -lah --tree'
    alias tree='lsd -lh --tree'
fi

# File management
alias md='mkdir -p'
alias rd='rmdir'
alias rmf='rm -rf'

# Clipboard (macOS built-ins)
alias c='pbcopy'
alias p='pbpaste'

# Git
alias gs="git status -sb"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gw="git switch"
alias gb="git branch"
alias gcm="git checkout main"
alias gundo='git reset --soft HEAD~1'
alias gamend='git commit --amend --no-edit'
alias glog='git log --graph --pretty=format:"%C(auto)%h%d %s %C(blue)%cr %C(green)(%an)" --all'

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....='cd ../../..'

# Misc
alias cl="clear"
alias by="exit"
alias v='nvim'
alias lg='lazygit'
alias tx='tmux'
alias py='python3'
alias ports='lsof -nP -iTCP -sTCP:LISTEN'   # macOS replacement for ss
alias fzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# File manager fallback
if command -v yazi >/dev/null 2>&1; then
    alias rr='yazi'
elif command -v ranger >/dev/null 2>&1; then
    alias rr='ranger'
else
    alias rr='echo "Neither yazi nor ranger is installed."'
fi

########## Homebrew Package Management ##########
if command -v brew &>/dev/null; then
    alias update='brew update && brew upgrade'
    alias install='brew install'
    alias remove='brew uninstall'
    alias search='brew search'
    alias info='brew info'
    alias cleanup='brew autoremove && brew cleanup'
fi

########## Plugins ##########
# Homebrew plugin paths
# Order matters: autosuggestions first, syntax-highlighting must be last

if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

########## External Tools ##########

command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
command -v atuin &>/dev/null && eval "$(atuin init zsh)"
# eval "$(thefuck --alias)"

command -v starship &>/dev/null && eval "$(starship init zsh)"

########## Syntax Highlighting (must be last) ##########
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

