# Check for an interactive session
[ -z "$PS1" ] && return

eval $(dircolors -b)
export EDITOR="vim"

## PS1 config 
# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

TTY=$(tty)
TTY=${TTY##*/}
current_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1|/'
}
git_since_last_commit() {
    now=`date +%s`;
    last_commit=$(git log --pretty=format:%at -1 2> /dev/null) || return;
    seconds_since_last_commit=$((now-last_commit));
    minutes_since_last_commit=$((seconds_since_last_commit/60));
    hours_since_last_commit=$((minutes_since_last_commit/60));
    minutes_since_last_commit=$((minutes_since_last_commit%60));
    echo "${hours_since_last_commit}h${minutes_since_last_commit}m)";
}
rvm_prompt() {
    version=$(~/.rvm/bin/rvm-prompt 2> /dev/null);
    [ -z ${version} ] && return;
    echo "(${version})";
}
get_current_window() {
    # Screen
    if [ $WINDOW ]; then
        echo "[W$WINDOW] ";
    elif [ $TMUX_PANE ]; then
        echo "[$TMUX_PANE] ";
    fi
}
color_by_last_exit_code() {
    if [[ $? = "0" ]]; then
        printf ${BCyan};
    else
        printf ${BRed};
    fi
}
PS1='\[$(color_by_last_exit_code)\[\A \['$BYellow'\]\u\['$BWhite'\]@\h \['$BRed'\][$TTY] \['$BPurple'\]$(get_current_window)\['$BGreen'\][\w] \['$Yellow'\]$(current_git_branch)$(git_since_last_commit)$(rvm_prompt) \['$Color_Off'\]\n\$ '
## END of PS1 config

alias diff='colordiff'              # requires colordiff package

export GREP_COLOR="1;33"
alias grep='grep --color=auto'

# ls
alias ls='ls --color=always'
alias ll='ls -al'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

complete -cf sudo
complete -cf man
complete -cf make

source /usr/share/git/completion/git-completion.bash

# Check window size on every prompt
shopt -s checkwinsize

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin 

# RVM bash completion
[[ -r "$HOME/.rvm/scripts/completion" ]] && source "$HOME/.rvm/scripts/completion"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"
