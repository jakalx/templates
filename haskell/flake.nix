{
  description = "Haskell Nix Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        overlay = final: prev: {
          haskell-template = final.callCabal2nix "haskell-template" ./. { };
        };

        haskellPackages = pkgs.haskell.packages.ghc924.extend overlay;
      in {
        packages.default = haskellPackages.haskell-template;

        apps = {
          default = {
            type = "app";
            program = "${self.defaultPackage.${system}}/bin/hello";
          };
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            settings = { ormolu.defaultExtensions = [ "GHC2021" ]; };
            tools.fourmolu = haskellPackages.fourmolu;
            hooks = {
              nixfmt.enable = true;
              fourmolu.enable = true;
              hpack.enable = true;
              hlint.enable = true;
            };
          };
        };

        devShells.default = haskellPackages.shellFor {
          inherit (self.checks.${system}.pre-commit-check) shellHook;

          packages = p: [ p.haskell-template ];

          withHoogle = true;

          nativeBuildInputs = with pkgs; [
            haskellPackages.haskell-language-server
            haskellPackages.fourmolu
            haskellPackages.hspec-discover
            haskellPackages.doctest
            cabal-install
            ghcid
            nixfmt
            hpack
            hlint
          ];
        };
      });
}
