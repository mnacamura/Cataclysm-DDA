let
  pkgs = import <nixpkgs> {
    overlays = [
      (import ./pkgs.nix)
      (import ~/repos/nixpkgs-cdda-mods)
    ];
  };
in

with import ./. { inherit pkgs; };

pkgs.mkShell {
  inputsFrom = [ debug.tiles ];

  buildInputs = with pkgs; [
    git
  ];

  CDDA_VERSION = builtins.getEnv "CDDA_VERSION";
}
