# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ -f /usr/share/bash-completion/completions/git ]
then
    source /usr/share/bash-completion/completions/git
else
    alias __git_ps1=true
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s) ")\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " (%s) ")\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -n "$SCHROOT_SESSION_ID" ]
then
    return
fi

export BB_NUMBER_THREADS=10
export PARALLEL_MAKE="-j10"
export DL_DIR=/var/cache/bitbake/downloads
export SSTATE_DIR=/var/cache/bitbake/sstate
export BB_ENV_PASSTHROUGH_ADDITIONS="DL_DIR SSTATE_DIR"

PATH=/home/andrew/.local/bin:"$PATH"

export EDITOR=hx

PS1="\j $PS1"

eval "$(direnv hook bash)"

export QNET="-net nic -net user,hostfwd=:127.0.0.1:2222-:22,hostfwd=:127.0.0.1:2443-:443,hostname=qemu"

export CC_LD=mold
export CXX_LD=mold

gen_opkg_conf ()
{
    local ipk_url="$1";
    local build_dir="$2";
    cat "${build_dir}"/tmp/deploy/ipk/**/Packages |
        grep --color=auto '^Architecture' |
        sort -u |
        awk "BEGIN { arch_prio=1 } { printf(\"arch %s %d\n\", \$2, arch_prio); arch_prio += 5; printf(\"src/gz %s %s/%s\n\", \$2, \"${ipk_url}\", \$2) }" |
        sort
}

efold()
{
    fold --spaces --width=72 -
}

ct()
{
    local d=$(pwd)
    local target="$1"
    cd ${d%/${target}/*}/${target}
}

. "$HOME/.cargo/env"

alias lsd="ls -1d"
alias muon=muon-meson

# Clone an OpenBMC project from Gerrit and set up for worktrees based on
# 'environments'. When dealing with forked code we often have trees that are
# out-of-date with respect to upstream. They have different requirements on
# dependencies, and so different build configurations. The difference between
# the environments is what causes pain on switching branches, so use a worktree
# per environment.
#
# The default environment is 'origin'
#
# The idea is that we have the following (example) directory structure:
#
# ~/src/openbmc.org/openbmc/openbmc.git
# ~/src/openbmc.org/openbmc/openbmc/<environment>
#
# Where ~/src/openbmc.org/openbmc/openbmc/<environment> is a worktree associated
# with ~/src/openbmc.org/openbmc/openbmc.git
openbmc-gerrit-clone()
{
    local repo="$1"
    local environment="$([ $# -ge 2 ] && echo "$2" || echo origin)"
    local url="ssh://amboar@gerrit.openbmc.org:29418/${repo}"
    local project="$(basename ${repo})"
    local clone="${project}.git"
    local tree="${project}/${environment}"
    git clone --separate-git-dir="${clone}" "${url}" "${tree}" &&
        (cd "${tree}" &&
            mkdir -p `git rev-parse --git-dir`/hooks/ &&
            curl -Lo `git rev-parse --git-dir`/hooks/commit-msg https://gerrit.openbmc.org/tools/hooks/commit-msg &&
            chmod +x `git rev-parse --git-dir`/hooks/commit-msg)
}

arj-clone()
{

    local url="$1"
    local project="$(basename "$url" .git)"
    local environment="$([ $# -ge 2 ] && echo "$2" || echo origin)"
    local clone="${project}.git"
    local tree="${project}/${environment}"
    git clone --separate-git-dir="${clone}" "${url}" "${tree}"
}

docive()
{
	for F in PXL*.jpg; do convert -resize 60% $F ${F%.jpg}.small.jpg; done
	for F in PXL*.small.jpg; do convert $F ${F%.jpg}.pdf; done
	pdftk *.pdf cat output "$1"
}
