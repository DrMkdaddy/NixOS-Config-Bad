# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    # ./anyrun.nix
    ./anyrun
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = true;
    };
  };

  # TODO: Set your username
  home = {
    username = "noor";
    homeDirectory = "/home/noor";
  };
  home.packages = with pkgs; [
    nerdfonts
    kitty
    waybar
    dunst
    grimblast
    python3
    wl-clipboard
    zoxide
    armcord
    nodePackages_latest.vim-language-server
    python311Packages.python-lsp-server
    pavucontrol
    brightnessctl
    nil
    element-desktop-wayland
    gh
    xdg-desktop-portal-hyprland
    firefox
    yaru-theme
  ];
  fonts.fontconfig.enable = true;

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Noor Mkdad";
      userEmail = "alph4nir@riseup.net";
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
      extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      };
    }; 
    starship.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    fish = {
    enable = true;
    shellInit =
    ''
        source (starship init fish --print-full-init | psub)
        zoxide init fish | source
    '';
    };
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  gtk = {
    enable = true;
    iconTheme = {
      name = "fluent-icon-theme";
      package = pkgs.fluent-icon-theme;
    };
    theme = {
      name = "yaru-dark";
      package = pkgs.yaru-theme;
    };
    cursorTheme = {
      name = "yaru-dark-cursor-thene";
      package = pkgs.yaru-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  home.sessionVariables.GTK_THEME = "yaru-dark";
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
