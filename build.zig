const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const root_module = b.addModule("root", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "jsc",
        .root_module = root_module,
    });
    exe.linkLibC();
    exe.linkFramework("JavascriptCore");
    exe.linkFramework("System");
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the demo");
    run_step.dependOn(&run_cmd.step);

    const lib = b.addLibrary(.{
        .name = "zig-javascriptcore",
        .root_module = root_module,
    });
    lib.linkLibC();
    lib.linkFramework("JavascriptCore");
    lib.linkFramework("System");
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_module = root_module,
    });
    main_tests.linkLibC();
    main_tests.linkFramework("JavascriptCore");
    main_tests.linkFramework("System");

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
