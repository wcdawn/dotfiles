#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# use colored prompts
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# always use vim
# this saves a keystroke and allows for sudo vim
alias vi='vim'

# set the prompt name
# ;1 is bold
# 31 is red
# 32 is green
# 33 is yellow
# 34 is blue
PS1="\[\e[34;1m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]\[\e[1m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\] \W\[\e[34;1m\]]\[\e[m\]\[\e[33;1m\]\$\[\e[m\]\[ \]"
export PROMPT_COMMAND="pwd > /tmp/whereami"

# start the x server if i3 isn't running
if [[ $(tty) == "/dev/tty1" ]]
then
  pgrep i3 || startx
fi

# set config alias for dotfiles
alias config='git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# swap escape and caps lock keys
setxkbmap -option caps:swapescape

# use bash vi mode
set -o vi

# set default editor
export EDITOR="vim"
export TERMINAL="urxvt"
export READER="zathura"
