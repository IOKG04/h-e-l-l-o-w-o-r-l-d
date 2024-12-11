const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const python_headers = b.addTranslateC(.{
        .root_source_file = .{ .cwd_relative = "/usr/include/python3.12/Python.h" },

        .optimize = optimize,
        .target = target,

        .link_libc = true,
    });

    python_headers.defineCMacroRaw("PY_SSIZE_T_CLEAN=");

    const lib = b.addSharedLibrary(.{
        .root_source_file = b.path("src/lib.zig"),
        .name = "tools",

        .optimize = optimize,
        .target = target,

        .link_libc = true,
    });

    lib.root_module.addImport("python", python_headers.createModule());

    b.installArtifact(lib);
}
