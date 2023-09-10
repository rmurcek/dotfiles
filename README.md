# Karabiner-Elements Setup
- Copy karabiner directory to $HOME/.config/karabiner
- Verify that it includes:
- For MSFT Keyboard (and not Apple Internal):
-- left_command -> left_option
-- left_option -> left_command
-- application -> right_command
- For Apple Internal Keyboard (and not MSFT Keyboard):
-- right_command -> right_option
-- right_option -> right_command

# OS Setup
Keyboard shortcuts -> Modifier Keys
- Karabiner DriverKit VirtualHIDKeyboard should be selected
-- Caps Lock -> Control

# Terminal Setup
- Symlink .zshrc and .zprofile to dotfiles versions
- Install Iterm2
- Import ITerm profile from dotfiles
- Set profile as default

# BetterTouchTool Setup
- Import profile from dotfiles
