# Set homebrew env vars and add to path
# For arm (default)
eval "$(/opt/homebrew/bin/brew shellenv)"
# For x86_64: switch to intel brew install
#eval "$(/usr/local/bin/brew shellenv)"

# Set pyenv env vars and add to path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
