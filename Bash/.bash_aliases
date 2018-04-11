#Aliases

alias c='clear'
alias h='history'
alias j='jobs -l'
alias .1='cd ..'
alias .2='cd ../../'
alias .3='cd ../../../'
alias ll='ls -l'
alias la='ls -al'
alias vi=vim
alias svi='sudo vi'
alias edit='vim'
alias now='date +"%T"'
alias timenow=now
alias datenow='date +"%m-%d-%y"'
alias diff='colordiff'
alias vimconfig='vim ~/.vimrc'
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias gitignorehere='curl https://raw.githubusercontent.com/idevHive/Settings/master/Git/.gitignore > .gitignore'
alias editalias='vim ~/.bash_aliases'
alias applyalias='source ~/.bashrc'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias upgrade='sudo apt-get update && sudo apt-get dist-upgrade'
alias fullupgrade='sudo apt-get update && sudo apt-get full-upgrade'
alias lampp='pathere=$(pwd) && cd /opt/lampp && sudo ./manager-linux-x64.run && cd $pathere && unset pathere'
alias gogit='cd ~/Documents/GIT/repo/'

#DNA = Download new aliases & UNA = Upload new aliases
alias dna='curl https://raw.githubusercontent.com/idevhive/Settings/master/Bash/.bash_aliases > ~.bashaliases'
#alias una=