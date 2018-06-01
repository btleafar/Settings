#Bash Aliases - This is compatible with Debian based systems only
#(because it uses 'APT' on the section starting in line 7)
#for general usage ignore/modify/remove reference to it. Although there is a version of
#this file for RPM bassed systems on my Github here:
#https://raw.githubusercontent.com/idevHive/Settings/master/Bash/.bash_aliases_fedora'

#System-based aliases
alias clean='sudo apt clean'
alias update='sudo apt update && sudo apt upgrade'
alias upgrade='sudo apt update && sudo apt dist-upgrade'
alias fullupgrade='sudo apt update && sudo apt full-upgrade'

#General Usage
alias c='clear'
alias h='history'
alias j='jobs -l'
alias .1='cd ..'
alias .2='cd ../../'
alias .3='cd ../../../'
alias ll='ls -l'
alias la='ls -al'
alias vi='vim'
alias svi='sudo vi'
alias edit='vim'
alias now='date +"%T"'
alias timenow='now'
alias datenow='date +"%m-%d-%y"'
alias diff='colordiff'
alias vimconfig='vim ~/.vimrc'
alias sublime='subl' #subl & sublime-text are the same
alias editalias='vim ~/.bash_aliases'
alias applyalias='source ~/.bashrc'

#Networks
alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'

#GIT-related aliases
alias gitignorehere='curl https://raw.githubusercontent.com/idevHive/Settings/master/Git/.gitignore > .gitignore'
alias gogit='cd ~/Documents/GIT/repo/'
alias gobash='cd ~/Documents/GIT/repo/Settings/Bash/'
alias gpl='git pull origin master'
alias gps='git push origin master'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
#DNA = Download new aliases & UNA = Upload new aliases
alias dna='curl https://raw.githubusercontent.com/idevhive/Settings/master/Bash/.bash_aliases_debian > ~/.bash_aliases'
alias una='pathere=$(pwd) && gobash && cp ~/.bash_aliases .bash_aliases_debian && ga . && gc "Update aliases for Debian" && gps && cd $pathere && unset pathere'

#XAMPP-related aliases
alias lampp='pathere=$(pwd) && cd /opt/lampp && sudo ./manager-linux-x64.run && cd $pathere && unset pathere'
