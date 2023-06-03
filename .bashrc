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
function _gvim_exe {
    local path_to_gvim="/mnt/d/Program Files (x86)/Vim/vim90/gvim.exe"
    #Don't split the filename
    local IFS=;
    local path_to_file="$(winpath $1)";
    "$path_to_gvim" "$path_to_file" $2 $3 $4 $5 $6 $7 $8 $9 &
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

#DrMemory (Valgrind alternative)
#GitHub.com/DynamoRIO/drmemory

push_path PATH "$HOME/DrMemory-Linux-2.2.18249-1/bin64"
#push_path PATH "$HOME/DrMemory-Linux-2.2.0-1/bin64"

#electronjs build tools and cache
push_path PATH "$HOME/src/depot_tools"
export GIT_CACHE_PATH="${HOME}/.git_cache"

#Eclipse 2019-12
#push_path PATH "$HOME/eclipse-2019-12"
push_path PATH "$HOME/eclipse/cpp-2020-06/eclipse"

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
