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

- Install Iterm2
- Import ITerm profile from dotfiles
- Set profile as default

# BetterTouchTool Setup
- Import profile from dotfiles

# OS Setup
- None required
- Remove any modifier key modifications

# Known issues
- karabiner.json seems to be overwritten and/or overrode possibly by Karabiner update or OSX update -- be sure to test immediately following updates to either
- karabiner sometimes fails to detect an external keyboard, especially when connected through a hub -- try restarting karabiner
