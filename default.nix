{ system ? builtins.currentSystem }:

let
  _pkgs = import <nixpkgs> { inherit system; };

  pkgs = import (_pkgs.fetchFromGitHub { owner = "guibou";
                                         repo = "nixpkgs";
                                         rev = "guibou_bump_szip";
                                         sha256 = null;}) {};
in (with pkgs; rec {
  # And this is dyson ! Yeah
  dyson = (pkgs.overrideCC pkgs.stdenv pkgs.gcc7).mkDerivation {
    name = "dyson";

    hardeningDisable = [ "all" ];

    # Hack because the code suppose some weird include
    # paths
    # Also it fails on warning, but some warning are here, so I
    # disabled those
    NIX_CFLAGS_COMPILE=''
      -I ${ilmbase.dev}/include/OpenEXR
      -I ${breakpad}/include/breakpad
      -DBOOST_LOG_DYN_LINK

      -Wno-unused-variable
      -Wno-unused-but-set-variable
    '';

    buildInputs = [
      cmake mesa dyson.tbb
      boost glew ilmbase microsoft_gsl python27 breakpad
      openimageio dyson.fontstash opensubdiv dyson.alembicOverride
      graphviz
    ]
      ++ (with python27Packages; [pyside numpy ]);

    passthru = {
      fontstash = callPackage ./fontstash.nix { };
      tbb = callPackage ./tbb.nix { };

      alembicOverride = alembic.override({
        hdf5 = dyson.hdf5Override;
      });

      hdf5Override = (hdf5.overrideAttrs (oldAttrs : rec {
        # enable threadsafety
        configureFlags = oldAttrs.configureFlags ++ ["--enable-threadsafe" "--disable-hl"];
      })).override ({
        # add support for a few compressing scheme
        szip = szip;
        zlib = zlib;
      });
    };
  };
})
