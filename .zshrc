##ME
DEFAULT_USER="joey"
# path to oh my zsh
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

# history
HISTSIZE=1000
SAVEHIST=1000

# variables
export PATH=${HOME}/.bin:/bin:${PATH}
# specific path for OS cross compiler
export PATH=${HOME}/code/projects/JoOS/opt/cross/bin:${PATH}
export TERM=xterm-256color
export EDITOR="vim"
export GOPATH="/home/joey/code/go"

# raspberry pi ttl connection alias
alias rpi='sudo screen /dev/ttyUSB0 115200'

# woops typed vi! alias
alias vi='vim'
# always fill in all mkdir's
alias mkdir='mkdir -p'

# et lul
alias please='sudo'
alias such='git'
alias very='git'
alias wow='git status'
alias gg='sudo shutdown now'

# functions
ac() { # compress a file or folder
    case "$1" in
       tar.bz2|.tar.bz2) tar cvjf "${2%%/}.tar.bz2" "${2%%/}/" ;;
       tbz2|.tbz2) tar cvjf "${2%%/}.tbz2" "${2%%/}/" ;;
       tbz|.tbz) tar cvjf "${2%%/}.tbz" "${2%%/}/" ;;
       tar.xz) tar cvJf "${2%%/}.tar.gz" "${2%%/}/" ;;
       tar.gz|.tar.gz) tar cvzf "${2%%/}.tar.gz" "${2%%/}/" ;;
       tgz|.tgz) tar cvjf "${2%%/}.tgz" "${2%%/}/" ;;
       tar|.tar) tar cvf "${2%%/}.tar" "${2%%/}/" ;;
           rar|.rar) rar a "${2}.rar" "$2" ;;
       zip|.zip) zip -9 "${2}.zip" "$2" ;;
       7z|.7z) 7z a "${2}.7z" "$2" ;;
       lzo|.lzo) lzop -v "$2" ;;
       gz|.gz) gzip -v "$2" ;;
       bz2|.bz2) bzip2 -v "$2" ;;
       xz|.xz) xz -v "$2" ;;
       lzma|.lzma) lzma -v "$2" ;;
           *) echo "ac(): compress a file or directory."
            echo "Usage: ac <archive type> <filename>"
                echo "Example: ac tar.bz2 PKGBUILD"
            echo "Please specify archive type and source."
            echo "Valid archive types are:"
            echo "tar.bz2, tar.gz, tar.gz, tar, bz2, gz, tbz2, tbz,"
            echo "tgz, lzo, rar, zip, 7z, xz and lzma." ;;
    esac
}
ad() { # decompress archive (to directory $2 if wished for and possible)
   if [ -f "$1" ] ; then
case "$1" in
           *.tar.bz2|*.tgz|*.tbz2|*.tbz) mkdir -v "$2" 2>/dev/null ; tar xvjf "$1" -C "$2" ;;
       *.tar.gz) mkdir -v "$2" 2>/dev/null ; tar xvzf "$1" -C "$2" ;;
       *.tar.xz) mkdir -v "$2" 2>/dev/null ; tar xvJf "$1" ;;
       *.tar) mkdir -v "$2" 2>/dev/null ; tar xvf "$1" -C "$2" ;;
       *.rar) mkdir -v "$2" 2>/dev/null ; 7z x "$1" "$2" ;;
       *.zip) mkdir -v "$2" 2>/dev/null ; unzip "$1" -d "$2" ;;
       *.7z) mkdir -v "$2" 2>/dev/null ; 7z x "$1" -o"$2" ;;
       *.lzo) mkdir -v "$2" 2>/dev/null ; lzop -d "$1" -p"$2" ;;
       *.gz) gunzip "$1" ;;
       *.bz2) bunzip2 "$1" ;;
       *.Z) uncompress "$1" ;;
       *.xz|*.txz|*.lzma|*.tlz) xz -d "$1" ;;
       *)
       esac
else
echo "Sorry, '$2' could not be decompressed."
              echo "Usage: ad <archive> <destination>"
              echo "Example: ad PKGBUILD.tar.bz2 ."
              echo "Valid archive types are:"
              echo "tar.bz2, tar.gz, tar.xz, tar, bz2,"
              echo "gz, tbz2, tbz, tgz, lzo,"
              echo "rar, zip, 7z, xz and lzma"
   fi
}
al() { # list content of archive but don't unpack
    if [ -f "$1" ]; then
case "$1" in
       *.tar.bz2|*.tbz2|*.tbz) tar -jtf "$1" ;;
       *.tar.gz) tar -ztf "$1" ;;
       *.tar|*.tgz|*.tar.xz) tar -tf "$1" ;;
       *.gz) gzip -l "$1" ;;
       *.rar) rar vb "$1" ;;
       *.zip) unzip -l "$1" ;;
       *.7z) 7z l "$1" ;;
       *.lzo) lzop -l "$1" ;;
       *.xz|*.txz|*.lzma|*.tlz) xz -l "$1" ;;
         esac
else
echo "Sorry, '$1' is not a valid archive."
     echo "Valid archive types are:"
     echo "tar.bz2, tar.gz, tar.xz, tar, gz,"
     echo "tbz2, tbz, tgz, lzo, rar"
     echo "zip, 7z, xz and lzma"
    fi
}

# Show some status info
status() {
    print "Date  : "$(date "+%Y-%m-%d %H:%M:%S")
    print "Shell : Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
    print "Term  : $TTY ($TERM), ${BAUD:+$BAUD bauds, }$COLUMNS x $LINES chars"
    print "Login : $LOGNAME (UID = $EUID) on $HOST"
    print "Uptime:$(uptime)"
    print "$(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
}

#zsh plugins
plugins=(git archlinux npm bundler rbates)

# load up ohmyzsh and plugins
source $ZSH/oh-my-zsh.sh
source $ZSH/zsh-syntax-highlighting-filetypes.zsh

# load up ls colours
eval $(dircolors -b $HOME/.dircolors)

