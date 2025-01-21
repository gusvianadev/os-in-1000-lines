const print_runtime = @import("print_runtime.zig").print_runtime;
const std = @import("std");

/// Sadly there's currently no way to, when calling @src() inside a function, get that function's caller
/// src information instead of the function itself
pub fn panic(
    comptime src: std.builtin.SourceLocation,
    comptime fmt: []const u8,
    args: anytype,
) void {
    print_runtime("PANIC: {s}:{d}: " ++ fmt ++ "\n", .{ src.file, src.line } ++ args);
    while (true) asm volatile ("");
}
