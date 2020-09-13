# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let
  paths = {
    nixosConfig = "/home/jon/nix/configuration.nix";
    #nixosConfig = "/etc/nixos/configuration.nix";
    #nixpkgs = "/home/jon/projects/nixpkgs";
    nixpkgs="/nix/var/nix/profiles/per-user/root/channels/nixos";
    overlays="/home/jon/nix/overlays";
  };
  overlays = [(import ./overlays/neovim.nix)];
in {
  nix.nixPath = [ 
    "nixos-config=${paths.nixosConfig}"
    "nixpkgs=${paths.nixpkgs}"
    "nixpkgs-overlays=${paths.overlays}"
  ];

  #nix.nixPath = [ "nixos-config=${paths.nixosConfig}" "nixpkgs=${paths.nixpkgs}" ];

  imports = [ 
    (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos")
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/cachix.nix
  ];


  home-manager.users.jon = { config, ... }: {
    
    home.packages = [];

    home.file = {
      ".config/nvim/init.vim".source = config.lib.file.mkOutOfStoreSymlink "/home/jon/nix/neovim/init.vim";
      ".config/nvim/coc-settings.json".source = config.lib.file.mkOutOfStoreSymlink "/home/jon/nix/neovim/coc-settings.json";
      ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/jon/nix/kitty/kitty.conf";
      ".config/kitty/theme.conf".source = config.lib.file.mkOutOfStoreSymlink "/home/jon/nix/kitty/ayu_mirage.conf";
      ".config/fish/fish_variables".source = config.lib.file.mkOutOfStoreSymlink "/home/jon/nix/fish/fish_variables";
    };

    programs.home-manager.enable = true;
    programs.fish.enable = true;
    programs.fish.plugins = [
      {
        name = "theme-l";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-l";
          rev = "97a15e58c7f8048b6e2460fdf385d3fba08c8adf";
          sha256 = "1sjsnd4wn1zxail88liwplhfamqg2n0ihlivb2fv840r676f9ky3";
        };
      }
    ];
    xdg.configFile."fish/conf.d/plugin-theme-l.fish".text = lib.mkAfter ''
      for f in $plugin_dir/*.fish
        source $f
      end
      set fish_greeting "Swimmy swim swim..."
    '';
  };

  programs.bash.shellAliases = with paths; {
    noc = "sudo nvim ${paths.nixosConfig}";
    nor = "sudo nixos-rebuild switch";
  };

  
  nixpkgs.config = {
    allowUnfree = true;
  };
  
  nixpkgs.overlays = overlays;
  #for emacs
  #nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #  }))
  #];

  environment.systemPackages = with pkgs;
    let
    in
      [
        binutils-unwrapped # for haskell cabal
        patchelf
        nix-direnv
        direnv
        haskellPackages.zlib
        file
        p7zip
        feh
        mpv
        android-file-transfer
        texlive.combined.scheme-full
        escrotum
        inkscape
        v4l-utils
        anki
        ripgrep
        firefox-bin
        libreoffice-fresh
        zathura
        nodejs
        yarn
        neovim
        keepassx2
        git
        typora
        coursier
        jre
        sbt
        nix-prefetch-git
        steam-run-native
        kakoune
        kitty
        fish
      ];

  environment.variables.EDITOR = "nvim";
  # for emacs
  #nix.extraOptions = ''
  #  keep-outputs = true
  #  keep-derivations = true
  #'';
  #environment.pathsToLink = [
  #  "/share/nix-direnv"
  #];

  fonts.fonts = with pkgs; [
    fira-code
    jetbrains-mono
  ];

  services.xserver.xkbOptions = "grp:alt_space_toggle, caps:ctrl_modifier";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "America/NewYork";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.autoRepeatDelay = 190;
  services.xserver.autoRepeatInterval = 30;
  # services.xserver.xkbOptions = "eurosign:e";
  
  # Mouse acceleration
  services.xserver = {
    libinput.enable = true; # enable libinput
    libinput.accelProfile = "flat"; # flat profile for touchpads
    synaptics.enable = false; # disable synaptics

    # flat profile for mice
    config = ''
      Section "InputClass"
        Identifier     "My mouse"
        Driver         "libinput"
        MatchIsPointer "on"
        Option "AccelProfile" "flat"
      EndSection
    '';
  };

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jon = {
#    name = 'jon';
#    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
 #   createHome = true;
#    home = '/home/jon';
    shell = pkgs.fish;
  };
  #services.nixosManual.showManual = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
