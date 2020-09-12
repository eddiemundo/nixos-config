```
mkdir ~/nix
cd ~/nix
git clone https://github.com/eddiemundo/nixos-config.git
sudo nixos-rebuild -I nixos-config=configuration.nix switch
```

#### Pretty simple (bad) setup

`configuration.nix` manages all packages for all users. We only need the root to have a nix channel.\
`home-manager` is configured inside `configuration.nix` and is for dotfile management only.\

#### For development
```
cp nix-shell/haskell <project-directory>
cd <project-directory>
nix-shell
```
TODO: Should fix paths not to point to user, or be hardcoded.
