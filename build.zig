const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "jsc",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    exe.linkFramework("JavascriptCore");
    exe.linkFramework("System");
    b.installArtifact(exe);

    const lib = b.addLibrary(.{
        .name = "zig-javascriptcore",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .kind = .static,
    });
    lib.linkLibC();
    lib.linkFramework("JavascriptCore");
    lib.linkFramework("System");
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    main_tests.linkLibC();
    main_tests.linkFramework("JavascriptCore");
    main_tests.linkFramework("System");

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
