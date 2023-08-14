PS1="\n\[\033[1;34m\][\w]$\[\033[0m\] "

export TERM=xterm-256color

if [[ $(uname -s) == Linux ]]
then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi

alias ll="ls -l"
alias grep="grep --color=auto"

if [ -f $HOME/.bashrc_tesla ]; then
    . $HOME/.bashrc_tesla
fi

export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
