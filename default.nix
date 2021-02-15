let
  hostpkgs =  import <nixpkgs> {};
  src = hostpkgs.fetchgit {
    url = "https://gitlab.haskell.org/lexi.lambda/ghc.git";
    rev = "0c41a90251e3c0613cb85cb0a3c1327950d9dd7e";
    sha256 = "196z6wvrfc99mzfbld3fiyxmmmzfg4bnnzp6m74y5f5pl2b29dvl";
  };

  # src = fetchTarball "https://gitlab.haskell.org/lexi.lambda/ghc/-/archive/0c41a90251e3c0613cb85cb0a3c1327950d9dd7e/ghc-0c41a90251e3c0613cb85cb0a3c1327950d9dd7e.tar.gz";

  overlay = self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        # ghc8101 = super.haskell.packages.ghc8101.override {
        #   ghc = super.haskell.compiler.ghc8101.overrideAttrs (old: {
        #     inherit src;
        #   });
        # };
        ghcHEAD = super.haskell.packages.ghcHEAD.override {
          ghc = super.haskell.compiler.ghcHEAD.overrideAttrs (old: {
            inherit src;
          });
        };
      };
    };
  };
in

{ nixpkgs ? import <nixpkgs> { overlays = [ overlay ]; }
}:

let
  haskellPackages = nixpkgs.pkgs.haskell.packages.ghcHEAD.override {
    overrides = self: super: {
      eff = self.callCabal2nix "eff" ./eff {};
    };
  };
in haskellPackages.eff

  # src = fetchgit {
  #   url = "https://gitlab.haskell.org/lexi.lambda/ghc.git";
  #   rev = "32fb000184181752addc55f670a7cb28d1058425";
  #   sha256 = "19rgp7pi7lqyjxwx9a4jm95mhkd46ik7lvd80f0wvsfg2m7ya7h3";
  # };


  #     ghcHEAD = callPackage ${nixpkgs}/packages/development/haskell-modules {
  #     buildHaskellPackages = bh.packages.ghcHEAD;
  #     ghc = bh.compiler.ghcHEAD;
  #     compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
  #   };

# nixpkgsHost.override {
#   override
# }
