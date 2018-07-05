{ pkgs ? import <nixpkgs> {
    overlays = [
      (import ./pkgs.nix)
      (import ~/repos/nixpkgs-cdda-mods)
    ];
  }
}:

with pkgs;

let
  target = cataclysm-dda-git.overrideAttrs (old: rec {
    name = "cataclysm-dda-git-${version}";
    version = builtins.getEnv "CDDA_VERSION";

    src = ./.;

    patches = [
      ./fix_locale_dir.patch
    ];

    makeFlags = old.makeFlags ++ [
      "VERSION=git-${version}"
    ];

    enableParallelBuilding = true;
  });
in

rec {
  debug = {
    console = withCcache (target.override {
      debug = true;
      tiles = false;
    });

    tiles = withCcache (target.override {
      debug = true;
    });
  };

  release = {
    console = target.override {
      tiles = false;
    };

    tiles = target;

    tilesWithMods = with cataclysmDDAPackages;
    wrapCDDA release.tiles {
      packages = [
        soundpack.atmark
      ];
    };
  };
}
