# Readme
Welcome to my dotfiles!

# Manual setup
After copying, rebuilding and running the symlink-script the following steps remains:
- Add user and email to git `git config --global user.name "XXX"` and `git config --global user.email "XXX"`
- Import the `unstable` channel for some packages with `sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable` and `sudo nix-channel --update`
- Create `~/.config/nixpkgs/config.nix.` and put `{ allowUnfree = true; }` inside of it 
- Run `unset SSH_ASKPASS` if needed 
