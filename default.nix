let
  hostpkgs =  import <nixpkgs> {};
  rev = "e81b78a68f54db78b5569fd9403c4b4aaeab7f13";
  src = hostpkgs.fetchgit {
    url = "https://gitlab.haskell.org/lexi.lambda/ghc.git";
    inherit rev;
    sha256 = "1x20vzdfc951j5x8y6wfc42i32j2gpkm4sgixz16y5pf3qsyfy32";
  };

  # src = fetchTarball "https://gitlab.haskell.org/lexi.lambda/ghc/-/archive/0c41a90251e3c0613cb85cb0a3c1327950d9dd7e/ghc-0c41a90251e3c0613cb85cb0a3c1327950d9dd7e.tar.gz";

  overlay = self: super: let
    ghc = (super.haskell.compiler.ghcHEAD.override { version = "8.11.20200115"; }).overrideAttrs (old: {
      inherit src;
    });
  in {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        # ghc8101 = super.haskell.packages.ghc8101.override {
        #   ghc = super.haskell.compiler.ghc8101.overrideAttrs (old: {
        #     inherit src;
        #   });
        # };
        ghcHEAD = super.haskell.packages.ghcHEAD.override {
          inherit ghc;
        };
        # ghc901 = super.haskell.packages.ghc901.override {
        #   inherit ghc;
        # };
      };
      compilers = super.haskell.compilers // {
        ghcHEAD = ghc;
        # ghc901 = ghc;
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
