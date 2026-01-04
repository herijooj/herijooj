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

        apps.deploy = {
          type = "app";
          program = toString (pkgs.writeShellScript "deploy" ''
            set -euo pipefail
            DEPLOY_BRANCH="gh-pages"
            GIT="${pkgs.git}/bin/git"

            echo "🔨 Building site with Nix..."
            RESULT=$(nix build --no-link --print-out-paths)

            echo "🚀 Deploying to $DEPLOY_BRANCH..."
            
            # Use a temp directory for the deploy
            DEPLOY_DIR=$(mktemp -d)
            trap "rm -rf $DEPLOY_DIR 2>/dev/null || true" EXIT

            # Clone the repo to temp dir (bare minimum, just .git)
            $GIT clone --no-checkout --single-branch . "$DEPLOY_DIR"
            cd "$DEPLOY_DIR"

            # Create or checkout gh-pages
            if $GIT show-ref --verify --quiet "refs/remotes/origin/$DEPLOY_BRANCH"; then
                $GIT checkout "$DEPLOY_BRANCH"
            else
                $GIT checkout --orphan "$DEPLOY_BRANCH"
                $GIT rm -rf . 2>/dev/null || true
            fi

            # Clean and copy built site
            $GIT rm -rf . 2>/dev/null || true
            cp -r "$RESULT"/* .
            touch .nojekyll

            # Commit and push
            $GIT add -A
            $GIT commit -m "Deploy: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" || echo "No changes to commit"
            $GIT push origin "$DEPLOY_BRANCH" --force

            echo "✅ Deployed to $DEPLOY_BRANCH!"
          '');
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