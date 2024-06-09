# List all aliases
alias get-aliases="less ~/.bash_aliases"

# General utilities
alias get-date="date '+%Y-%m-%d %H:%M:%S'"

# Homebrew shortcuts
alias check-update="brew update; brew outdated"
alias upgrade-all="brew upgrade; brew cleanup"

# Locate utility - update database
alias updatedb="sudo /usr/libexec/locate.updatedb"
alias createdb="sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist"

# Networking
alias my-ip="curl -k https://checkip.amazonaws.com/"
alias find-neighbors="sudo arp-scan --interface="$(ifconfig | grep en0 | awk -F ":" 'NR==1{print $1}')" --localnet"

# Navigation
alias ls="ls -l -a"

# UTM virtual machine directory
alias utm-dir="cd /Users/d0zzzr/Library/Containers/com.utmapp.UTM/Data/Documents"

# Music and video
alias get-music="yt-dlp --extract-audio --audio-format mp3"
alias get-video="yt-dlp -S res,ext:mp4:m4a --recode mp4"
alias goto-music="cd ~/Music"

# Navigation
alias goto-repos="cd ~/Lab/repos"

# Conda
alias auto-activate-check="conda config --show | grep auto_activate_base"
alias auto-activate-true="conda config --set auto_activate_base True"
alias auto-activate-false="conda config --set auto_activate_base False"
