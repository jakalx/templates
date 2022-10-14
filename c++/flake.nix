{
  description = "C++ nix flake using cmake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        example = (with pkgs;
          stdenv.mkDerivation {
            pname = "c++-template";
            version = "0.0.1";
            src = ./.;

            nativeBuildInputs = [ clang cmake ninja ];
            buildInputs = [ doctest ];
          });

        packageName = "c++-template";
      in rec {
        apps.example = flake-utils.lib.mkApp {
          drv = defaultPackage;
          name = "hello";
        };
        defaultApp = apps.example;
        defaultPackage = example;

        devShell = pkgs.mkShell {
          buildInputs = with pkgs;
            lib.concatLists [
              [ cmake-format cmake-language-server ]
              example.nativeBuildInputs
              example.buildInputs
            ];
        };
      });
}
