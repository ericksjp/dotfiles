export NODE_ENV="development"
export TERM=xterm-256color

# a parada do nvm ai q eu não faço ideia como funciona mas tem q ta ai
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/go/bin:/usr/local/bin:$GOROOT/bin:$GOPATH/bin:$HOME/go:$HOME/go/bin:$HOME/.cargo/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

# eval "$(tmuxifier init -)"
eval "$(zoxide init zsh)"

# alias brm="java -jar /home/erick/Softwares/brModelo/dist/brModelo.jar"
alias renameall="/home/erick/projects/myscripts/utils/rename_all.sh"

alias rekeyd='sudo cp ~/.config/keydBoard.conf /etc/keyd/AT\ Translated\ Set\ 2\ keyboard.conf && sudo systemctl restart keyd'

alias o="/bin/xdg-open"
alias c="clear"

alias e="/bin/nvim"
# alias vim="/bin/nvim"
# alias vi="/bin/vim"
alias nano="/bin/nvim"
# alias v="/bin/nvim"

alias j='tmux new-session \; run-shell ~/.config/tmux/plugins/tmux-resurrect/scripts/restore.sh'

alias m="/home/erick/projects/myscripts/tmux/sessionizer.sh"

alias nn="$HOME/projects/myscripts/notes/new_note.sh"
alias nd="cd ~/vaults/"
alias nm="$HOME/projects/myscripts/notes/move_perm_notes_to_respective_dirs.sh"
alias no="nvim /home/erick/vaults/inbox/*.md -c 'lua buffers_to_tabs()'"

alias lag="lazygit"

# rclone aliases
# alias rup='rclone sync /home/erick/vaults vault:'
# alias rdw='rclone sync vault: /home/erick/vaults'

bindkey '^H' backward-kill-word

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="half-life"
ZSH_THEME="bira"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

DISABLE_AUTO_TITLE="true"

function stitle() {
  echo -en "\e]2;$@\a"
}

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . "/home/erick/.deno/env"

## THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# 
## pnpm
# export PNPM_HOME="/home/erick/.local/share/pnpm"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac
## pnpm end
# eval "$(~/.local/bin/mise activate)"

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
# source /usr/share/doc/fzf/examples/completion.zsh
# source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# eval "$(~/.local/bin/mise activate)"
