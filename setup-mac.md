# Setting up a new Mac

Not well tested, may be incomplete. Use at your own risk.

- Install Xcode via App Store
- Install the CLI tools: `xcode-select --install`
- Install Homebrew from https://brew.sh # `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  - On Apple Silicon this lands in `/opt/homebrew`, on Intel in `/usr/local`. `profile` detects both.
- Run `brew doctor` and resolve any issues
- Run `rake system:install_formulae` for the listed formulae
- Run `rake config:install` to symlink the dotfiles

## Shells

macOS defaults to zsh. `rake config:install` symlinks `~/.zshrc`, `~/.bashrc`
and `~/.bash_profile`, all of which source the shared `~/.profile`.

Note that zsh does *not* read `~/.profile` on its own — `~/.zshrc` is what
pulls it in. If you add a login-shell-only tweak, put it in `~/.zprofile`
(untracked, machine-specific).

