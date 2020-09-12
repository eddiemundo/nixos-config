```
mkdir ~/nix
cd ~/nix
git clone https://github.com/eddiemundo/nixos-config.git
sudo nixos-rebuild -I nixos-config=configuration.nix
```

Pretty simple/bad setup:

`configuration.nix` manages all packages for all users.
`home-manager` config is located inside `configuration.nix` and is for dotfile management only.

Should fix paths not to point to user, or be hardcoded.
