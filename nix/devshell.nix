{pkgs}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [pkg-config];
  buildInputs = with pkgs;
    [
      # Rust dependencies
      (rust-bin.stable.latest.default.override {extensions = ["rust-src"];})
    ]
    ++ lib.optionals stdenv.isLinux [
      # for Linux
      wayland
      # Audio (Linux only)
      alsa-lib
      # Cross Platform 3D Graphics API
      vulkan-loader
      # For debugging around vulkan
      vulkan-tools
      # Other dependencies
      libudev-zero
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      libxkbcommon
    ];
  env = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    LD_LIBRARY_PATH = with pkgs;
      lib.makeLibraryPath [
        vulkan-loader
        xorg.libX11
        xorg.libXi
        xorg.libXcursor
        libxkbcommon
      ];
  };
}
