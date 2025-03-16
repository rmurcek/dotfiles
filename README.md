# Machine Setup
- Install homebrew (https://brew.sh/)
- Install pyenv (https://github.com/pyenv/pyenv?tab=readme-ov-file#macos)
  - No need to update env/rc -- ohmyzsh pyenv plugin takes care of it
- Install oh my zsh (https://github.com/ohmyzsh/ohmyzsh/tree/master)
  - Note this will replace zshrc (you can find it at .zshrc.pre-oh-my-zsh)
- Install emacs (https://wikemacs.org/wiki/Installing_Emacs_on_OS_X)

# Karabiner-Elements Setup
- Copy karabiner directory to $HOME/.config/karabiner
- Verify that it includes:
  - For all devices
    - caps_lock -> left_control
  - For MSFT Keyboard (and not Apple Internal):
    - left_command -> left_option
    - left_option -> left_command
    - application -> right_command
  - For Apple Internal Keyboard (and not MSFT Keyboard):
    - right_command -> right_option
    - right_option -> right_command

# Terminal Setup
- Symlink .zshrc and .zprofile to dotfiles versions
  - ln -s $HOME/code/dotfiles/.zprofile $HOME/.zprofile
  - ln -s $HOME/code/dotfiles/.zshrc $HOME/.zshrc

# Install Iterm2
- Import ITerm profile from dotfiles
- Set profile as default

# BetterTouchTool Setup
- Import profile from dotfiles - how?

# OS Setup
- None required
- Remove any modifier key modifications

# Known issues
- karabiner.json seems to be overwritten and/or overrode possibly by Karabiner update or OSX update -- be sure to test immediately following updates to either
- karabiner sometimes fails to detect an external keyboard, especially when connected through a hub -- try restarting karabiner
