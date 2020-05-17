# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions

alias cl='clear'
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
alias h='history'
alias less='less -x4 -Mir'
alias ls='ls -F --color=auto'
alias mkdir='mkdir -p'
alias who='who|sort'
alias clean='find . -name "*~"  -exec rm {} \;'
alias ne='emacs -nw'
alias rssh='ssh -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias rscp='scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

export PERL5LIB=/root/z/bin
