{ description = "Heric's Hugo Site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hericsite";
          version = "0.1.0";
          src = ./.;

          buildInputs = [ pkgs.hugo ];

          buildPhase = ''
            hugo --minify
          '';

          installPhase = ''
            cp -r public $out
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            hugo
            git
            watchexec
            markdownlint-cli
          ];

          shellHook = ''
            echo "Dev shell ready: $(hugo version)"
            alias mlint="markdownlint '**/*.md'"
          '';
        };
      });
}