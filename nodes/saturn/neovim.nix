{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      neovim = prev.neovim.overrideAttrs (
        finalAttrs: previousAttrs: {
          passthru = previousAttrs.passthru // {
            makeFhs =
              { extraPython3Packages, extraPackages }:
              let
                neovimConfig = final.neovimUtils.makeNeovimConfig {
                  inherit extraPython3Packages;
                  withNodeJs = true;
                  withRuby = true;
                  withPython3 = true;
                  # https://github.com/NixOS/nixpkgs/issues/211998
                  customRC = "luafile ~/.config/nvim/init.lua";
                };
                nvim = final.wrapNeovimUnstable final.neovim-unwrapped neovimConfig;
                nvim-fhs = final.buildFHSEnv {
                  name = "nvim";
                  targetPkgs =
                    pkgs:
                    (with pkgs; [
                      # ld-linux-x86-64-linux.so.2 and others
                      glibc
                      lua5_1
                      python3
                      go
                      tree-sitter
                      gcc
                      cmake
                      pkg-config
                      gnumake
                      zlib
                    ])
                    ++ (extraPackages pkgs)
                    ++ [ nvim ];
                  runScript = "${nvim}/bin/nvim";
                };
              in
              final.symlinkJoin {
                name = "neovim-fhs-${finalAttrs.version}";
                paths = [
                  nvim-fhs
                  nvim
                ];
                passthru = {
                  # inherit executableName;
                  inherit (finalAttrs) pname version;
                };
                meta = finalAttrs.meta // {
                  description = ''
                    Wrapped variant of ${finalAttrs.pname} which launches in a FHS compatible environment.
                    Should allow for easy usage of extensions without nix-specific modifications.
                  '';
                };
              };
          };
        }
      );
    })
  ];

  environment.systemPackages = [
    (pkgs.neovim.makeFhs {
      extraPython3Packages =
        p: with p; [
          pynvim
          debugpy
          ipython
          ipykernel
          ilua
          numpy
          pandas
          # Molten-nvim requirements
          jupyter-client
          cairosvg # for image rendering
          pnglatex
          plotly
          kaleido
          pyperclip
          nbformat
          pillow
          requests
          websocket-client
        ];
      extraPackages =
        pkgs: with pkgs; [
          icu
          imagemagick
          python3Packages.jupytext
          python3Packages.pylatexenc
        ];
    })
  ];
}
