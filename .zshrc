# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.dotfiles/oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  asdf
  brew
  docker
  docker-compose
  emacs
  git
  macos
  vscode
  history-substring-search
  pyenv
)


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Chrome
alias ch='open -a "Google Chrome"'
# Emacs
alias e=te

export EDITOR='emacs'

# repo
alias repo="cd ~/code/metropolis-io/site"

# git
alias gl='git log'
alias ga='git add -A'
alias gs='git status'
alias gst='git stash'
alias gss='git stash show'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gsd='git stash drop'
alias gb='git branch'
alias gp='git pull --rebase origin $(git rev-parse --abbrev-ref HEAD)'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grh='git reset head --hard'
alias gc='git commit'
alias gca='git commit --amend'
alias gpf='git push -f'
alias gpsu='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gbb="git for-each-ref --sort='-authordate:iso8601' --format=' %(authordate:relative)%09%(refname:short)' refs/heads"
alias gclean='git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

# Docker bindings
alias dcs='docker-compose stop'
alias dcu='docker-compose up --build'
alias dcuscout='docker-compose up --build scout scout-flask'
alias dcupilot='docker-compose up --build pilot pilot-flask'
alias dcudispatch='docker-compose up --build dispatch dispatch-flask'
alias dcucp='docker-compose up --build copilot-flask'
alias dcusvs='docker-compose up --build svs svs-flask'
alias dcudeepthought='docker-compose up --build deepthought'
alias dcssvs='docker-compose stop svs svs-flask'
alias dcsscout='docker-compose stop scout scout-flask'
alias dcspilot='docker-compose stop pilot pilot-flask'
alias dcrm='docker-compose rm -v'
alias dcrmf='docker-compose rm -v pilot scout svs screenshot'
alias dsp='docker system prune -a --volumes'
alias dcrpilot='docker-compose restart pilot pilot-flask'
alias dcrflask='docker-compose restart pilot-flask scout-flask svs-flask'
alias dcr='docker-compose restart'

# Support aliases as sudo (only the first simple command on a line is checked for aliases unless the first ends in a space)
alias sudo='sudo '

# Stepful (see: https://github.com/stepful/stepful?tab=readme-ov-file )
alias rs='bundle exec rails' # rails command abstraction
alias p='pnpm' # package manager abstraction
# export EDITOR="code --wait" # for commands like `rs credentials:edit` to open vscode


# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home"
export JAVA_OPTS="-Xms4g -Xmx8g -XX:NewSize=256m -XX:MaxNewSize=356m -XX:MaxMetaspaceSize=8g"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python
# export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
# source /usr/local/bin/virtualenvwrapper.sh

# Docker
export COMPOSE_HTTP_TIMEOUT=300

# Set up postgres commands for server installed by Postgres App
# export PGDATA='$HOME/Library/Application Support/Postgres/var-10'
# export PGHOST=localhost

# opam configuration
test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"



eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/postgresql@13/bin:$PATH"
export LDFLAGS="-L$(brew --prefix openssl)/lib"
#export LDFLAGS="-L$(brew --prefix openssl)/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib -L/opt/homebrew/opt/ruby/lib"
#export LDFLAGS="-I/usr/local/opt/openssl/include -L/usr/local/opt/openssl/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib -L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I$(brew --prefix openssl)/include"
#export CPPFLAGS="-I$(brew --prefix openssl)/include-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include -I/opt/homebrew/opt/ruby/include"
#export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include -I/opt/homebrew/opt/ruby/include"


# For pkg-config to find ruby you may need to set:
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

# Initialize virtualenvwrapper
# source $HOME/.local/bin/virtualenvwrapper.sh

# Add ruby to path
# 2.6.5 installed via brew
export PATH="/usr/local/opt/ruby/bin:$PATH"

alias rad='radish -b e2e_tests/validation e2e_tests/features --with-traceback --early-exit --user-data "user=Rob Murcek" --user-data "headless=true" -u "env=local" --tags "test and not wip"'
alias radpreprod='radish -b e2e_tests/validation e2e_tests/features --with-traceback --early-exit --user-data "user=Rob Murcek" --user-data "headless=true" -u "env=preprod" --tags "test and not wip"'
alias radhead='radish -b e2e_tests/validation e2e_tests/features --with-traceback --early-exit --user-data "user=Rob Murcek" --user-data "headless=false" -u "env=local" --tags "test and not wip"'
alias rtest='radish-test --cover-show-missing --cover-min-percentage=100 -b e2e_tests/validation matches e2e_tests/validation/step-matches.yml'


# 1Password
alias op-signin='eval $(op signin trialspark)'
alias aptible-login='aptible login --email=rob@trialspark.com --lifetime=2d --password $(op list items --tags aptible | op get item - --fields password) --otp-token $(op list items --tags aptible | op get totp -)'

function aws-login
{
    local -r aws_entry="$(op list items --tags aws)"
    local -r username="$(echo $aws_entry | op get item - --fields username)"
    local -r mfa_token="$(echo $aws_entry | op get totp -)"
    cd "$HOME/code/spark"
    pipenv run python ./scripts/get_aws_session_credentials.py --user "$username" --mfa "$mfa_token"
    cd -
}

function is_installed
{
        command -v "$1" >/dev/null 2>&1
}


export PATH="/usr/local/sbin:$PATH"

# # Install terraform vault
# is_installed vault || return

# export VAULT_ADDR='https://vault.trialspark.com:8200'
# export VAULT_CACERT='~/code/terraform/certs/vault-ca.crt'
