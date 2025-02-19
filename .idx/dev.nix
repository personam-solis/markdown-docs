# To learn more about how to use Nix to configure your environment -
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    # pkgs.go
    pkgs.python312
    pkgs.conda
    pkgs.python312Packages.conda
    # pkgs.python311Packages.pip
    # pkgs.nodejs_20
    # pkgs.nodePackages.nodemon
  ];

  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      # "vscodevim.vim"
      "esbenp.prettier-vscode"
      "ms-python.debugpy"
      "ms-python.pylint"
      "ms-python.python"
      "ms-toolsai.jupyter"
      "ms-toolsai.jupyter-keymap"
      "ms-toolsai.jupyter-renderers"
      "ms-toolsai.vscode-jupyter-cell-tags"
      "ms-toolsai.vscode-jupyter-slideshow"
      "redhat.vscode-yaml"
      "yzhang.markdown-all-in-one"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        # web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
        #   command = ["npm" "run" "dev"];
        #   manager = "web";
        #   env = {
        #     # Environment variables to set for your server
        #     PORT = "$PORT";
        #   };
        # };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      onCreate = {
        # Runs a script on workspace creation
        conda-setup = ''
          #!/bin/bash
          set -e

          # Initialize conda
          conda init bash
          conda create -n default312 python=3.12 jupyter boto3 pyyaml psycopg2 sqlite pip -y
          echo "Conda environment 'default312' with Python 3.12 is ready."
        '';
      };
      # Runs when the workspace is (re)started
      onStart = {
        # Example: start a background task to watch and re-build backend code
        # watch-backend = "npm run watch-backend";
        
        activate-conda = ''
          conda activate default312
        '';      };
    };
  };
}