{ pkgs ? import <nixpkgs> {} }:

let
  # Lighthouse needs a browser to audit pages
  chromium = pkgs.chromium;
in

pkgs.mkShell {
  # CLI tools available in the dev shell
  packages = with pkgs; [
    hugo           # Static site generator
    git            # optional, handy for versioning
    watchexec      # optional, for watching/rebuilding if desired
    imagemagick    # for image optimization
    gifsicle       # for GIF optimization
    libwebp        # for WebP conversion
    markdownlint-cli  # Markdown linter
    nodejs_20      # Required for lighthouse CLI
    chromium       # Browser for lighthouse audits
  ];

  shellHook = ''
    echo "Dev shell ready: $(hugo version)"
    alias hbuild="hugo"
    alias hminify="hugo --minify"
    alias hserve="hugo server -D"
    alias hclean="rm -rf public"
    alias gstatus="git status"
    alias gpush="git push"
    alias gpull="git pull"
    alias mlint="markdownlint '**/*.md'"
    alias lh="npx lighthouse --output json --output html --output path ./lighthouse-report"
  '';
}
