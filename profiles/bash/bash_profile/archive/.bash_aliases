# Navigation
alias ls="ls -l -a"

# Media
alias get_video="yt-dlp"
alias get_music="yt-dlp --extract-audio --audio-format mp3"
alias go_to_music="cd /mnt/c/Users/rdagl/Music/downloads"

# System
alias check_update="sudo apt update && sudo apt list --upgradable -a"
alias upgrade_all="sudo apt upgrade -y && sudo apt dist-upgrade -y"
alias upgrade_clean="sudo apt autoremove --purge && sudo apt clean"

# Utils
alias show_aliases="less ~/.bash_aliases"

# Connect to network hosts
alias connect_app_server="ssh wisp@10.0.0.157"
alias connect_file_server="ssh wisp@10.0.0.106"
alias connect_db_server="ssh wisp@10.0.0.4"

