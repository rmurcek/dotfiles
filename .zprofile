# Set homebrew env vars and add to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Set pyenv env vars and add to path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
