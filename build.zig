const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .riscv32, .os_tag = .freestanding, .abi = .none });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSmall });

    const exe = b.addExecutable(.{
        .name = "kernel.elf",
        .root_source_file = b.path("src/kernel.zig"),
        .target = target,
        .optimize = optimize,
        .strip = false,
    });

    exe.setLinkerScript(b.path("src/kernel.ld"));
    exe.entry = .disabled;

    b.installArtifact(exe);

    const run_cmd = b.addSystemCommand(&.{
        "qemu-system-riscv32",
    });

    run_cmd.addArgs(&.{
        "-machine",
        "virt",
        "-bios",
        "default",
        "-serial",
        "mon:stdio",
        "--no-reboot",
        "-nographic",
        "-kernel",
    });

    run_cmd.addArtifactArg(exe);

    const run_step = b.step("run", "Run QEMU");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/kernel.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
