{
  description = "MinilibX-Linux development environment with Bazel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # X11 and graphics libraries needed for MinilibX
        mlxDeps = with pkgs; [
          # X11 core libraries
          xorg.libX11
          xorg.libXext
          xorg.libXrandr
          xorg.libXinerama
          xorg.libXcursor
          xorg.libXi
          xorg.libXfixes

          # Additional X11 utilities
          xorg.xorgproto
          xorg.libxcb

          # Graphics libraries
          mesa
          libGL
          libGLU
          glfw
          glew

          # Compression and utilities
          zlib
          libbsd

          # Build tools
          pkg-config
          gnumake
          cmake
        ];

        # Development tools
        devTools = with pkgs; [
          gcc
          gdb
          clang-tools
          lldb
          valgrind

          # Bazel and build tools
          bazel_7
          buildifier
          buildozer

          # Version control and utilities
          git

          # Documentation tools
          man-pages
          man-pages-posix
        ];

        # Generate workspace_deps.bzl with proper header structure
        workspaceDeps = pkgs.writeText "workspace_deps.bzl" ''
          load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
          load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")

          def load_dependencies():
              """Load all external dependencies for minilibx"""

              # X11 library
              maybe(
                  new_local_repository,
                  name = "x11",
                  path = "${pkgs.xorg.libX11.dev}",
                  build_file_content = """
          cc_library(
              name = "x11",
              hdrs = glob(["include/**/*.h"]),
              includes = ["include"],
              linkopts = [
                  "-L${pkgs.xorg.libX11}/lib",
                  "-lX11",
                  "-Wl,-rpath,${pkgs.xorg.libX11}/lib",
              ],
              visibility = ["//visibility:public"],
          )
                  """,
              )

              # Xext library
              maybe(
                  new_local_repository,
                  name = "xext",
                  path = "${pkgs.xorg.libXext.dev}",
                  build_file_content = """
          cc_library(
              name = "xext",
              hdrs = glob(["include/**/*.h"]),
              includes = ["include"],
              linkopts = [
                  "-L${pkgs.xorg.libXext}/lib",
                  "-lXext",
                  "-Wl,-rpath,${pkgs.xorg.libXext}/lib",
              ],
              visibility = ["//visibility:public"],
          )
                  """,
              )

              # X.org protocol headers
              maybe(
                  new_local_repository,
                  name = "xorg_proto",
                  path = "${pkgs.xorg.xorgproto}",
                  build_file_content = """
          cc_library(
              name = "xorg_proto",
              hdrs = glob(["include/**/*.h"]),
              includes = ["include"],
              visibility = ["//visibility:public"],
          )
                  """,
              )

              # zlib
              maybe(
                  new_local_repository,
                  name = "zlib",
                  path = "${pkgs.zlib.dev}",
                  build_file_content = """
          cc_library(
              name = "zlib",
              hdrs = glob(["include/**/*.h"]),
              includes = ["include"],
              linkopts = [
                  "-L${pkgs.zlib}/lib",
                  "-lz",
                  "-Wl,-rpath,${pkgs.zlib}/lib",
              ],
              visibility = ["//visibility:public"],
          )
                  """,
              )

              # libbsd
              maybe(
                  new_local_repository,
                  name = "libbsd",
                  path = "${pkgs.libbsd.dev}",
                  build_file_content = """
          cc_library(
              name = "libbsd",
              hdrs = glob(["include/**/*.h"]),
              includes = ["include"],
              linkopts = [
                  "-L${pkgs.libbsd}/lib",
                  "-lbsd",
                  "-Wl,-rpath,${pkgs.libbsd}/lib",
              ],
              visibility = ["//visibility:public"],
          )
                  """,
              )
        '';
      in {
        devShells.default = pkgs.mkShell {
          name = "minilibx-bazel-dev";

          buildInputs = mlxDeps ++ devTools;

          # Set up environment variables for X11 and graphics
          shellHook = ''
            echo "🎨 MinilibX-Linux Development Environment"
            echo "=========================================="
            echo ""
            echo "Available tools:"
            echo "  • Bazel ${pkgs.bazel_7.version}"
            echo "  • GCC $(gcc --version | head -n1 | cut -d' ' -f3-)"
            echo "  • X11 libraries: libX11, libXext"
            echo ""

            # Create workspace_deps.bzl with Nix library paths
            echo "Generating workspace_deps.bzl with Nix library paths..."
            cat ${workspaceDeps} > workspace_deps.bzl

            echo "Build commands:"
            echo "  bazel build //..."
            echo ""
            echo "Bazel configurations:"
            echo "  bazel build --config=opt    # Optimized build"
            echo "  bazel build --config=debug  # Debug build"
            echo ""

            # Set up library paths for runtime
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath mlxDeps}:$LD_LIBRARY_PATH"

            # Ensure X11 can be found
            export DISPLAY=''${DISPLAY:-:0}

            # Set up PKG_CONFIG_PATH for finding libraries
            export PKG_CONFIG_PATH="${pkgs.lib.concatMapStringsSep ":" (p: "${p}/lib/pkgconfig") mlxDeps}"

            # Bazel cache directory
            export BAZEL_CACHE_DIR="$HOME/.cache/bazel"
            mkdir -p "$BAZEL_CACHE_DIR"

            # Set CC and CXX for consistency
            export CC="${pkgs.gcc}/bin/gcc"
            export CXX="${pkgs.gcc}/bin/g++"
          '';

          # Additional Nix-specific configuration
          NIX_HARDENING_ENABLE = "";
        };
      }
    );
}
