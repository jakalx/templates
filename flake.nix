# SPDX-FileCopyrightText: 2021 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: CC0-1.0

{
  description = "My haskell application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskellPackages;

        jailbreakUnbreak = pkg:
          pkgs.haskell.lib.doJailbreak (pkg.overrideAttrs (_: { meta = { }; }));

        packageName = "haskell-nix-template";
      in {
        packages.${packageName} = haskellPackages.callCabal2nix packageName self
          rec {
            # Dependency overrides go here
          };

        defaultPackage = self.packages.${system}.${packageName};

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt.enable = true;
              ormolu.enable = true;
              hpack.enable = true;
              hlint.enable = true;
            };
          };
        };

        devShell = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;

          buildInputs = with pkgs; [
            haskellPackages.haskell-language-server
            ghcid
            ormolu
            cabal-install
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };
      });
}
