{
  description = "Schemas for documented bidirectional JSON encoding";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        haskellPackages = pkgs.haskellPackages.override {
          overrides = self: super: {
            schema-profunctor =
              super.callCabal2nix "schema-profunctor" ./. { };
          };
        };
      in {
        packages.default = haskellPackages.schema-profunctor;

        devShells.default = haskellPackages.shellFor {
          packages = p: [ p.schema-profunctor ];
          buildInputs = with haskellPackages; [
            cabal-install
            ghcid
            haskell-language-server
            hlint
            ormolu
          ];
          withHoogle = true;
        };
      });
}
