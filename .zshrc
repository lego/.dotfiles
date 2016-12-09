# zsh configuration
DEFAULT_USER="joey"
## Path to your oh-my-zsh installation.
ZSH=$HOME/.oh-my-zsh

# terminal configuration
setopt appendhistory
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions colored-man-pages npm bundler rails ruby rvm vagrant gem adb bower gitfast github node pip)

bindkey '``' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=3  # Options: 1, 2, 3, 4
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")

setopt autocd extendedglob nomatch notify
unsetopt correct

export TERM=xterm-256color

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# Preferred options: robbyrussell, soliah, kafeitu, gallifrey, nebirhos,
# philips, cypher, dstufft, risto, half-life, jbergantine, norm, essembeh
# fina (should be personalized more), murilasso, nebirhos
ZSH_THEME="agnoster"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

if [[ "$(uname)" == "Darwin" ]]; then
  # OS X specific setup
  plugins+=(osx brew)
  export CLICOLOR=YES
  # export LSCOLORS="$(cat $HOME/.dircolors)"
else
  # ArchLinux specific setup
  plugins+=(archlinux)
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
