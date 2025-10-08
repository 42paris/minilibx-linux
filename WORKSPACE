load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_pkg",
    sha256 = "62eeb544ff1ef41e945d20e1a3a3851b1bb9f1f8828f3f4b6608b5a2fe04a2da",
    strip_prefix = "rules_pkg-0.9.1",
    urls = ["https://github.com/bazelbuild/rules_pkg/releases/download/0.9.1/rules_pkg-0.9.1.tar.gz"],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

# X11 (example for Ubuntu/Debian; use your distro's repo or build from source)
http_archive(
    name = "x11",
    build_file = "@//:x11.BUILD",  # You'll need to create this
    sha256 = "your_sha256_here",  # Compute with `sha256sum` on the .deb/.rpm
    urls = ["http://archive.ubuntu.com/ubuntu/pool/main/libx/libx11/libx11-6_1.6.4-3ubuntu0.2_amd64.deb"],  # Example URL
    type = "deb",
)

# Xext (similarly)
http_archive(
    name = "x11_xext",
    build_file = "@//:xext.BUILD",
    sha256 = "your_sha256_here",
    urls = ["http://archive.ubuntu.com/ubuntu/pool/main/libx/libxext/libxext6_1.3.3-1build4_amd64.deb"],
    type = "deb",
)

