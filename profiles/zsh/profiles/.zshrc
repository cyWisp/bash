autoload -Uz compinit
compinit

# Load custom profile
source /Users/rdaglio/.zprofile

# Load kubectl autocompletion
source <(kubectl completion zsh)

# bun completions
[ -s "/Users/rdaglio/.bun/_bun" ] && source "/Users/rdaglio/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# postgres TODO: find relevant path
# export PATH=/Library/PostgreSQL/15/bin:$PATH

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

