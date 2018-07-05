self: super:

{
  ccacheWrapper = super.ccacheWrapper.override {
    extraConfig = ''
      export CCACHE_COMPRESS=1
      export CCACHE_DIR=/var/cache/ccache
      export CCACHE_UMASK=007
    '';
  };

  withCcache = pkg:
  pkg.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ self.ccacheWrapper ];

    # collect2: error: ld returned 1 exit status
    # make[1]: *** [Makefile:35: cata_test] Error 1
    # make[1]: Leaving directory '/tmp/nix-build-cataclysm-dda-git-0.D-13330-g415e4cc082.drv-0/Cataclysm-DDA/tests'
    # make: *** [Makefile:1111: tests] Error 2
    broken = true;
  });

  SDL2 = super.SDL2.override {
    fcitxSupport = self.stdenv.isLinux;
  };
}
