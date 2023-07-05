{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        defaultPackage =
          # Notice the reference to nixpkgs here.
          stdenv.mkDerivation rec {
            buildInputs = [
              mdbook
              mdbook-katex
              mdbook-emojicodes
              mdbook-d2
              mdbook-pdf
              mdbook-plantuml
              chromium # To create the pdf
              d2
              rust-bin.stable.latest.default
            ];
            name = "hello";
            src = self;
            buildPhase = ''
              mkdir book
              mdbook build -d book
            '';
            installPhase = "mdbook build -d $out";
            
          };
        
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            exa
            fd
            mdbook
            mdbook-katex
            mdbook-emojicodes
            mdbook-d2
            mdbook-pdf
            mdbook-plantuml
            chromium # To create the pdf
            d2
            rust-bin.stable.latest.default
          ];

          shellHook = ''
            alias ls=exa
            alias find=fd
          '';
        };
      }
    );
}
