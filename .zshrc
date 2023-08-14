PROMPT=$'\n''[%F{blue}%~%f] %# '

if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi

if [[ $(uname -s) == Linux ]]
then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi

alias ll="ls -l"

export PATH=~/.cargo/bin:$PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/local/opt/ruby/bin:$PATH"

