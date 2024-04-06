# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
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

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

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

    imports = [
      ./dconf.nix
    ];

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
      wl-clipboard
      docker-compose
      gnupg
      sops
      mc
      libreoffice
      feh
      teams-for-linux
      dconf2nix
      dropbox
      ripgrep
      fd
      gimp
      gparted
      ntfs3g
      nixpkgs-fmt
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
          tmuxPlugins.gruvbox
          tmuxPlugins.tmux-fzf
          tmuxPlugins.fzf-tmux-url
        ];
      extraConfig = ''
                  setw -g mode-keys vi
                  unbind C-b
                  set -g prefix C-a
                  bind C-a send-prefix
                  bind-key C-a last-window
        	  set-option -sa terminal-features ',foot:RGB'
        	'';
    };

    services.emacs.enable = true;

    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

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
        vim-rhubarb
        vimagit
        {
          plugin = oil-nvim;
          type = "lua";
          config = ''
            	    require('oil').setup()
            	  '';
        }
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects

        gruvbox-material
        vim-code-dark
        papercolor-theme
        mini-nvim
        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = ''
            	    -- disable netrw at the very start of your init.lua
                        vim.g.loaded_netrw = 1
                        vim.g.loaded_netrwPlugin = 1

                        -- optionally enable 24-bit colour
                        -- vim.opt.termguicolors = true

                        -- empty setup using defaults
            	    require('nvim-tree').setup()
                        vim.api.nvim_set_keymap('n', '<leader>\\', [[<cmd>NvimTreeToggle<CR>]], { })
            	    vim.api.nvim_set_keymap('n', '<leader>\\\\', [[<cmd>NvimTreeFindFile<CR>]], { })
            	  '';
        }
        vim-tmux-navigator
        vim-tmux-clipboard
        vim-unimpaired
        vim-dadbod
        vim-dadbod-ui
        vim-dadbod-completion

        plenary-nvim
        telescope-nvim
        {
          plugin = fzf-lua;
          type = "lua";
          config = ''
            vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>tt", "<cmd>lua require('fzf-lua').tabs()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>g", "<cmd>lua require('fzf-lua').live_grep_glob()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>gg", "<cmd>lua require('fzf-lua').grep()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>lg", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>gl", "<cmd>lua require('fzf-lua').grep_last()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>gp", "<cmd>lua require('fzf-lua').grep_project()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>gC", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>gc", "<cmd>lua require('fzf-lua').grep_cWORD()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>gb", "<cmd>lua require('fzf-lua').lgrep_curbuf()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>jj", "<cmd>lua require('fzf-lua').jumps()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>rr", "<cmd>lua require('fzf-lua').registers()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>cc", "<cmd>lua require('fzf-lua').changes()<CR>", { silent = true })
            vim.keymap.set("n", "<leader>bb", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })

            local actions = require "fzf-lua.actions"

            require'fzf-lua'.setup{
              actions = {
                -- These override the default tables completely
                -- no need to set to `false` to disable an action
                -- delete or modify is sufficient

                files = {

                  -- providers that inherit these actions:
                  --   files, git_files, git_status, grep, lsp
                  --   oldfiles, quickfix, loclist, tags, btags
                  --   args
                  -- default action opens a single selection
                  -- or sends multiple selection to quickfix
                  -- replace the default action with the below
                  -- to open all files whether single or multiple
                  -- ["default"]     = actions.file_edit,

                  ["default"]     = actions.file_edit_or_qf,
                  ["ctrl-s"]      = actions.file_split,
                  ["ctrl-v"]      = actions.file_vsplit,
                  ["ctrl-t"]      = actions.file_tabedit,
                  ["alt-q"]       = actions.file_sel_to_qf,
                  ["alt-l"]       = actions.file_sel_to_ll,
                  ["ctrl-i"]      = actions.toggle_ignore,
                },
               },
            }
          '';
        }

        {
          plugin = nvim-surround;
          type = "lua";
          config = ''
            	    require('nvim-surround').setup()
            	  '';
        }

        {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            	    require('lualine').setup({
            	      extensions = { "fugitive", "fzf", "quickfix" },
            	      options = {
            	        icons_enabled = true,
            		theme = 'auto',
            	      },
            	      tabline = {},
            	    })
            	  '';
        }

        {
          plugin = bufferline-nvim;
          type = "lua";
          config = ''
            	    require('bufferline').setup({
            	      options = {
            	        mode = "tabs",
            		numbers = "ordinal",
            	      },
            	    })
            	    vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>")
            	    vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>")
            	    vim.keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>")
            	    vim.keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>")
            	    vim.keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>")
            	    vim.keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>")
            	    vim.keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>")
            	    vim.keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>")
            	    vim.keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>")
            	  '';
        }

        {
          plugin = comment-nvim;
          type = "lua";
          config = ''
            	    require('Comment').setup()
            	  '';
        }

        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = ''
            	    require('ibl').setup()
            	  '';
        }

        vim-signify

        {
          plugin = aerial-nvim;
          type = "lua";
          config = ''

            require("aerial").setup({
                on_attach = function(bufnr)
                    -- Toggle the aerial window with <leader>a
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a', '<cmd>AerialToggle!<CR>', {})
                    -- Jump forwards/backwards with '{' and '}'
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '{', '<cmd>AerialPrev<CR>', {})
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '}', '<cmd>AerialNext<CR>', {})
                end
            })

	  '';
        }

      ];
      extraConfig = ''
                colorscheme PaperColor
                " Highlight on yank
                augroup YankHighlight
                autocmd!
                autocmd TextYankPost * silent! lua vim.highlight.on_yank()
                augroup end
                au FileType python setlocal equalprg=black\ -\ 2>/dev/null
                au FileType nix setlocal equalprg=nixpkgs-fmt
                "set clipboard+=unnamedplus
                "set clipboard^=unnamed,unnamedplus
                let g:db_ui_use_nerd_fonts = 1
        	" --Zooming Vim Window Splits like a Pro
        	noremap Zz <c-w>_ \| <c-w>\|
        	noremap Zo <c-w>=
      '';
      extraLuaConfig = ''
        	--Remap space as leader key
                vim.g.mapleader = ' '
                vim.g.maplocalleader = ','

                vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
                vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>")
                vim.keymap.set("n", "<leader><Tab>", "<cmd>b#<cr>")
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

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "Hack Nerd Font Mono";
          dpi-aware = "yes";
        };
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gnome.gnome-tweaks
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
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
