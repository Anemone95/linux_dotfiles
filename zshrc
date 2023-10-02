# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# p10k
# zinit
# Install:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
#   mkdir ~/.zinit
#   git clone https://github.com/zdharma/zinit.git ~/.zinit/bin

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone --depth=1 https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
      zdharma-continuum/zinit-annex-rust \
      zdharma-continuum/zinit-annex-as-monitor \
      zdharma-continuum/zinit-annex-patch-dl \
      zdharma-continuum/zinit-annex-bin-gem-node

### End of Zinit's installer chunk

# Set $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
 

# Oh-My-Zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
zinit light zsh-users/zsh-syntax-highlighting

zinit ice lucid wait='0' atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# using local private key when using ssh
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zinit snippet OMZP::ssh-agent/ssh-agent.plugin.zsh

## add completions
zinit ice lucid wait="0"
zinit light zsh-users/zsh-completions
# last completion need atload
zinit ice lucid wait="0" atload="zpcompinit; zpcdreplay"
zinit snippet OMZ::plugins/git/git.plugin.zsh
## end


# Other plugin
zinit ice lucid wait="0"
zinit load agkozak/zsh-z

# common config
source $HOME/.shconfig.sh

# Theme(p10k)
zinit ice depth=1; zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
