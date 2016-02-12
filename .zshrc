# terminal configuration
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

export TERM=xterm-256color

# zsh configuration
DEFAULT_USER="joey"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"

if [[ "$(uname)" == "Darwin" ]]; then
  # OS X specific setup
  plugins=(osx brew npm bundler rails ruby rvm vagrant gem adb bower gitfast github node pip)
  export CLICOLOR=YES
  # export LSCOLORS="$(cat $HOME/.dircolors)"
else
  # ArchLinux specific setup
  plugins=(archlinux npm bundler rails ruby rvm vagrant gem adb bower gitfast github node pip)
  eval $(dircolors -b $HOME/.dircolors)
fi

# initialize oh my zsh
source $ZSH/oh-my-zsh.sh
if [ -f $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ -f $ZSH/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh ]; then
  source $ZSH/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh
fi

setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

# external imports
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`
# * ~/.exports can be used for generic exports.
# * ~/.aliases can be used for generic aliases
# * ~/.functions can be used to isolate functions for clean bash files :)
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
  [ -r "$file" ] && source "$file"
done
unset file
## external archlinux specific stuff
if [ -f /etc/arch-release ]; then
  source ~/.zshconfig_archlinux
fi
