# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

function urlescape {
    local IFS=;
    echo "urlescape argument: \$1=$1" >&2
    #Replace anything other than A-Z or 1-9 with
    #a percent(%) and the hexadecimal codepoint
    #No, $ARGV[0] is not the name of the program in Perl, that's $0.
    local encoded=$(perl -Mutf8 -Mwarnings -Mstrict -E \
        '#No, $ARGV[0] is not the name of the program in Perl, that'\''s $0.
         my $s=$ARGV[0];
         if(not defined $s) {
             exit;
         }
	 #Replace anything other than A-Z or 1-9 with
	 #A percent(%) and the hexadecimal codepoint
         $s =~ s/([^a-zA-Z1-9])/"%".sprintf("%x", ord($1))/egg;
         say $s' $1)
    echo "urlescape result: $encoded" >&2
    echo "$encoded"
}
SEARCHENGINE=DDG
#Find the query string that each search engine uses.
function what-search-engine {
    case $SEARCHENGINE in 
        [Gg]oogle) echo "https://google.com/search?q=";;
        [Dd]uck[Dd]uck[Gg]o|DDG) echo "https://duckduckgo.com/?q=";;
        [Bb]ing) echo "https://www.bing.com/search?q=";;
        [Yy]ahoo) echo "https://search.yahoo.com/search?p=";;
        #This leaks $SEARCHENGINE variable to
        #DDG, but I think this is how to do a "bang search"
        *) echo "https://duckduckgo.com/?q=!$SEARCHENGINE+";;
    esac
}
function google {
    echo Escape arguments 1 to 9
    local one=$(urlescape "$1")
    local two=$(urlescape "$2")
    local three=$(urlescape "$3")
    local four=$(urlescape "$4")
    local five=$(urlescape "$5")
    local six=$(urlescape "$6")
    local seven=$(urlescape "$7")
    local eight=$(urlescape "$8")
    local nine=$(urlescape "$9")
    echo Getting query string for $SEARCHENGINE
    local querystring=$(what-search-engine)
    local url="${querystring}$one+$two+$three+$four+$five+$six+$seven+$eight+$nine"
    echo "Going to open $url"
    echo -- "\$1=\"$1\" \$2=\"$2\" \$3=\"$3\" \$4=\"$4\" \$5=\"$5\" \$6=\"$6\" \$7=\"$7\" \$8=\"$8\" \$9=\"$9\""
    echo "Running xdg-open"
    xdg-open $url
}
#Convert WSL path (/mnt/c, /mnt/d, etc.) to Windows path (c:\, d:\, etc.)
function winpath {
    local file=$1

    if test "x${file:0:5}" = "x/mnt/";then
        file="$(echo $file | sed 's!/mnt/\([a-z]\)/!\1:\\!')";
    fi
    file="$(echo "$file" | sed 's!/!\\!g')";
    echo $file;
}
function _run_vim {
    local IFS=;
    local path_to_vim="$1"
    local path_to_file="$(winpath $2)";
    "$path_to_vim" "$path_to_file" $3 $4 $5 $6 $7 $8 $9 &
}
function _gvim_exe {
    local path_to_gvim="/mnt/d/Program Files (x86)/Vim/vim90/gvim.exe"
    #Don't split the filename
    local IFS=;
    _run_vim $path_to_gvim $*
}
function _nvim_exe {
    local path_to_nvim="/mnt/d/Program Files/Neovim/bin/nvim-qt.exe"
    #Don't split the filename
    local IFS=;
    _run_vim $path_to_nvim $*
}
#Get out of system32
case $PWD in
    /mnt/c/[Ww][Ii][Nn][Dd][Oo][Ww][Ss]/[Ss][Yy][Ss][Tt][Ee][Mm]32)
        cd ~
esac

#Set up aliased commands
test -s ~/.alias && . ~/.alias || true

#This should work with (windows) Xming
export DISPLAY=:0

#https://superuser.com/questions/455212/how-to-make-mouse-wheel-scroll-the-less-pager-using-bash-and-gnome-terminal
export LESS=-asrMMRix8

#https://trzeci.eu/configure-graphic-and-sound-on-wsl
#https://github.com/Microsoft/WSL/issues/486#issuecomment-235655704
export PULSE_SERVER=tcp:localhost
#Avoid adding a path to $PATH twice
function push_path() {
    path_to_push="$2"
    #echo ${!1} in bash
    #echo "$"$1
    if echo ${!1} | grep -F $2 >& /dev/null;then
        : #nothing
    else
        # was "export $1+=:$2"
        # was "export $1=$$1:$2"
        export $1+=:$2
    fi
}
push_path PATH "$HOME/.local/bin"
#Include locally generated manpages (cppman)
push_path MANPATH "$HOME/.local/share/man"

push_path PATH "/usr/lib64"

#DrMemory (Valgrind alternative)
#GitHub.com/DynamoRIO/drmemory

push_path PATH "$HOME/DrMemory-Linux-2.2.18249-1/bin64"
#push_path PATH "$HOME/DrMemory-Linux-2.2.0-1/bin64"

#electronjs build tools and cache
#push_path PATH "$HOME/src/depot_tools"
#export GIT_CACHE_PATH="${HOME}/.git_cache"

#Eclipse 2019-12
#push_path PATH "$HOME/eclipse-2019-12"
push_path PATH "$HOME/eclipse/cpp-2020-06/eclipse"

# This fixes twig gem. Otherwise `twig init` doesn't work.
push_path PATH "$HOME/.gem/ruby/2.5.0/bin"

#Unexpand ~ in $PWD
function munge_pwd() {
    local home_to_escape="$HOME"
    #https://stackoverflow.com/questions/17542892/how-to-get-the-last-character-of-a-string-in-a-shell
    #lastchar="$((${#home_to_escape}-1))"
    #if test "${home_to_escape:$lastchar:1}" != "/";then
    #    home_to_escape="$home_to_escape/";
    #fi
    #https://stackoverflow.com/questions/407523/escape-a-string-for-a-sed-replace-pattern
    home_to_escape=$(echo $home_to_escape | sed -e 's/[]\/$*.^[]/\\&/g')

    echo "$PWD" | sed "s!$home_to_escape!~/!" | sed "s!//!/!g";
}
#https://askubuntu.com/questions/1025347/ubuntu-on-windows-how-can-i-set-the-title-bar-to-a-remote-server-prompt
#xtitle utility can be downloaded from https://kinzler.com/me/xtitle/
#Can't use the \cd (or \pushd, \popd) trick since it causes a stack overflow, so have to use 'command cd' etc.
function cd() {
    command cd "$1"
    xtitle -q -t $(munge_pwd);
}
function pushd() {
    command pushd "$@"
    xtitle -q -t $(munge_pwd);
}
function popd() {
    command popd "$@"
    xtitle -q -t $(munge_pwd);
}
#https://github.com/sirredbeard/Awesome-WSL/blob/master/README.md#9-gui-apps
#Enable hardware acceleration in X
#Commented out since it seems to cause XMing to
#crash with 'Resource Temporarily Unavailable' and
#causes VcXsrv to hang when Native OpenGL is checked.
#export LIBGL_ALWAYS_INDIRECT=1

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

fortune bible
. "$HOME/.cargo/env" #for Rust
[[ -s ~/.twig/twig-completion.bash ]] && source ~/.twig/twig-completion.bash

# -----------------------------------------------
#         Oh my Bash! below this comment
# -----------------------------------------------
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH='/mnt/d/Linux_home/nathan/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"
