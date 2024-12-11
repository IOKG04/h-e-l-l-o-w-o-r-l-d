const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const name = b.option([]const u8, "name", "Name of binary") orelse return error.NoName;

    const lib = b.addSharedLibrary(.{
        .root_source_file = b.path("src/lib.zig"),
        .name = name,

        .optimize = optimize,
        .target = target,

        .link_libc = true,
        // .strip = optimize != .Debug,
    });

    b.installArtifact(lib);

    // const install = b.addInstallArtifact(lib, .{
    //     .dest_dir = .{ .override = .{ .prefix = {} } },
    //     .dest_sub_path = null,
    // });

    // b.default_step.dependOn(&install.step);
}
