#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# use colored prompts
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# i actually use this all the time and it's pretty useful, though dumb...
alias ll='ls -halF'

# set the prompt name
# ;1 is bold
# 31 is red
# 32 is green
# 33 is yellow
# 34 is blue
export PS1="\[\e[34;1m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[1m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\] \W\[\e[34;1m\]]\[\e[m\]\[\e[33;1m\]\\$\[\e[m\] \[$(tput sgr0)\]"
echo $HOME > /tmp/whereami
export PROMPT_COMMAND="pwd > /tmp/whereami"

# dont keep duplicates in bash history
export HISTCONTROL=ignoreboth:erasedups

# set config alias for dotfiles
alias config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# use bash vi mode
set -o vi

# set default programs
export EDITOR='vim'
export TERMINAL="$HOME/.config/bspwm/my_term.sh"
export READER='zathura'
export TERM='xterm'
export BROWSER='firefox'
export PULSEAUDIO_SINK='alsa_output.pci-0000_09_00.1.hdmi-stereo'

# add bin directory in home to path
export PATH="$HOME/bin:$PATH"

# useful when moving around LUPINE directories
export LUPINE="$HOME/work/lupine/"

alias :q='echo "You are not in Vim..."; sleep 2; exit;'

# cuda 10.2
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
export PATH=$PATH:$CUDA_HOME/bin
