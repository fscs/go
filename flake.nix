{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "fscs-go";
          src = self;

          buildInputs = with pkgs; [
            mdbook
            mdbook-emojicodes
            mdbook-katex
          ];

          buildPhase = ''
            ${pkgs.lib.getExe pkgs.gnused} -i 's/\[output\.pdf\]//g ' book.toml

            mdbook build
          '';

          installPhase = "mdbook build -d $out/book";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            chromium # To create the pdf
            mdbook
            mdbook-emojicodes
            mdbook-katex
            mdbook-pdf
          ];
        };
      }
    );
}
