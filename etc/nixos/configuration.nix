# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      <sops-nix/modules/sops>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-64eebff0-b9bb-4833-a70c-696d7625edbf".device = "/dev/disk/by-uuid/64eebff0-b9bb-4833-a70c-696d7625edbf";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_PH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fil_PH";
    LC_IDENTIFICATION = "fil_PH";
    LC_MEASUREMENT = "fil_PH";
    LC_MONETARY = "fil_PH";
    LC_NAME = "fil_PH";
    LC_NUMERIC = "fil_PH";
    LC_PAPER = "fil_PH";
    LC_TELEPHONE = "fil_PH";
    LC_TIME = "fil_PH";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ildar = {
    isNormalUser = true;
    description = "ildar";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  home-manager.users.ildar = { pkgs, lib, ... }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
	allowUnfreePredicate = _: true;
      };
    };

    home.packages = with pkgs; [
      atool
      httpie
      tmux
      telegram-desktop
      wmctrl
      alacritty
      brave
      htop
      emacs
      git
#      neovim
      keepassxc
      maestral
      surfraw
      jq
      fzf
      nerdfonts
      microsoft-edge
      enlightenment.terminology
      foot
      xsel
      docker-compose
      gnupg
      sops
      mc
      libreoffice
      feh
      teams-for-linux
    ];
    programs.bash.enable = true;

    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 100000;
      plugins = with pkgs;
        [
	  tmuxPlugins.yank
	  tmuxPlugins.vim-tmux-navigator
	  tmuxPlugins.sensible
	  tmuxPlugins.sessionist
	  tmuxPlugins.resurrect
	  tmuxPlugins.pain-control
	];
	extraConfig = ''
          setw -g mode-keys vi
          unbind C-b
          set -g prefix C-a
          bind C-a send-prefix
          bind-key C-a last-window
	'';
    };
    
    services.emacs.enable = true;

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface".color-scheme = "prefer-light";
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-kyebindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Shift><Alt>c";
          command = "bash /home/ildar/configfiles/launchtool.sh emacs";
          name = "emacs";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Shift><Alt>d";
          command = "bash /home/ildar/configfiles/launchtool.sh brave";
          name = "brave";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
          binding = "<Shift><Alt>w";
          command = "emacsclient -cF \"((visibility . nil))\" -e \"(emacs-counsel-launcher)\"";
          name = "emacs-run-launcher";
        };
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "terminalte:ctrl_alt_bksp" "lv4:ralt_switch" "ctrl:nocaps" "grp:shifts_toggle" ];
	  sources = with lib.hm.gvariant; [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ru" ]) ];
	  mru-sources = with lib.hm.gvariant; [ (mkTuple [ "xkb" "en" ]) ];
        };
	"org/gnome/desktop/wm/preferences".num-workspaces = 9;
	"org/gnome/shell/app-switcher".current-workspace-only = false;
	"org/gnome/shell".disable-user-extensions = true;
	"org/gnome/desktop/wm/keybindings" = {
	  switch-to-workspace-1 = ["<Shift><Alt>1" "<Shift><Alt>x"];
	  switch-to-workspace-2 = ["<Shift><Alt>2"];
	  switch-to-workspace-3 = ["<Shift><Alt>3" "<Shift><Alt>f"];
	  switch-to-workspace-4 = ["<Shift><Alt>4"];
	  switch-to-workspace-5 = ["<Shift><Alt>5" "<Shift><Alt>t"];
	  switch-to-workspace-6 = ["<Shift><Alt>6"];
	  switch-to-workspace-7 = ["<Shift><Alt>7"];
	  switch-to-workspace-8 = ["<Shift><Alt>8"];
	  switch-to-workspace-9 = ["<Shift><Alt>9" "<Shift><Alt>k"];
	  move-to-workspace-1 = ["<Ctrl><Alt>1"];
	  move-to-workspace-2 = ["<Ctrl><Alt>2"];
	  move-to-workspace-3 = ["<Ctrl><Alt>3"];
	  move-to-workspace-4 = ["<Ctrl><Alt>4"];
	  move-to-workspace-5 = ["<Ctrl><Alt>5"];
	  move-to-workspace-6 = ["<Ctrl><Alt>6"];
	  move-to-workspace-7 = ["<Ctrl><Alt>7"];
	  move-to-workspace-8 = ["<Ctrl><Alt>8"];
	  move-to-workspace-9 = ["<Ctrl><Alt>9"];
	};
	"org/gnome/mutter".workspaces-only-on-primary = true;
      };
    };

    programs.git = {
      enable = true;
      userName = "Ildar Nasyrov";
      userEmail = "iledarnp@gmail.com";
      aliases = {
        co = "checkout";
        st = "status";
        hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        fugitive
        {
	  plugin = oil-nvim;
	  type = "lua";
	  config = ''
	    require('oil').setup()
	  '';
	}
	nvim-treesitter.withAllGrammars
	plenary-nvim
	gruvbox-material
	mini-nvim
	{
	  plugin = nvim-tree-lua;
	  type = "lua";
	  config = ''
	    require('nvim-tree').setup()
            vim.api.nvim_set_keymap('n', '<leader>\\', [[<cmd>NvimTreeToggle<CR>]], { })
	    vim.api.nvim_set_keymap('n', '<leader>\\\\', [[<cmd>NvimTreeFindFile<CR>]], { })
	  '';
	}
      ];
      extraConfig = ''
        colorscheme gruvbox-material
      '';
      extraLuaConfig = ''
	--Remap space as leader key
        vim.g.mapleader = ' '
        vim.g.maplocalleader = ','
      '';
    };

    home.sessionPath = [
      "/home/ildar/.config/emacs/bin"
    ];

    programs.ssh.enable = true;
    programs.ssh.matchBlocks = {
      kepiProd = {
        hostname = "139.162.11.95";
	user = "prod";
	identityFile = "/home/ildar/.ssh/id_ed25519";
      };
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gnome.gnome-tweaks
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
