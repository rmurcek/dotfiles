# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/rob/.oh-my-zsh"

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
  brew
  docker
  docker-compose
  emacs
  git
  osx
  vscode
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

# Emacs
alias e=te

export EDITOR='e'

# repo
alias repo="cd ~/code/spark"

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
alias gp='git pull --rebase origin master'
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
alias dcucp='docker-compose up --build copilot-flask'
alias dcusvs='docker-compose up --build svs svs-flask'
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
# export PGDATA='/Users/rob/Library/Application Support/Postgres/var-10'
# export PGHOST=localhost

# opam configuration
test -r /Users/rob/.opam/opam-init/init.zsh && . /Users/rob/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# export PATH="/usr/local/sbin:$PATH"
# export PATH="/usr/local/opt/postgresql@9.5/bin:$PATH"
