"""System library dependencies for non-Nix environments"""

load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")

def load_dependencies():
    """Load system-installed X11 libraries"""
    
    maybe(
        new_local_repository,
        name = "x11",
        path = "/usr",
        build_file_content = """
cc_library(
    name = "x11",
    srcs = [],
    linkopts = ["-lX11"],
    visibility = ["//visibility:public"],
)
""",
    )
    
    maybe(
        new_local_repository,
        name = "xext",
        path = "/usr",
        build_file_content = """
cc_library(
    name = "xext",
    srcs = [],
    linkopts = ["-lXext"],
    visibility = ["//visibility:public"],
)
""",
    )
    
    maybe(
        new_local_repository,
        name = "xorg_proto",
        path = "/usr",
        build_file_content = """
cc_library(
    name = "xorg_proto",
    srcs = [],
    visibility = ["//visibility:public"],
)
""",
    )
    
    maybe(
        new_local_repository,
        name = "xpm",
        path = "/usr",
        build_file_content = """
cc_library(
    name = "xpm",
    srcs = [],
    linkopts = ["-lXpm"],
    visibility = ["//visibility:public"],
)
""",
    )
    
    maybe(
        new_local_repository,
        name = "zlib",
        path = "/usr",
        build_file_content = """
cc_library(
    name = "zlib",
    srcs = [],
    linkopts = ["-lz"],
    visibility = ["//visibility:public"],
)
""",
    )
    
    maybe(
        new_local_repository,
        name = "libbsd",
        path = "/usr",
        build_file_content = """
cc_library(
    name = "libbsd",
    srcs = [],
    linkopts = ["-lbsd"],
    visibility = ["//visibility:public"],
)
""",
    )
