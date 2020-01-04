PROMPT=$'\n''[%F{blue}%~%f] %# '

if [[ $(uname -s) == Linux ]]
then
    alias ls="ls --color=auto"
else
    alias ls="ls -G"
fi

alias ll="ls -l"

export PATH=~/.cargo/bin:$PATH
