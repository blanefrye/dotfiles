PS1="\n\[\033[1;34m\][\w]$\[\033[0m\] "

export TERM=xterm-256color

export PYTHONPATH=/Users/bfrye/Documents/infrastructure:

if [[ $(uname -s) == Linux ]]
then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi

alias ls="ls --color=auto"
alias ll="ls -l"
alias grep="grep --color=auto"
