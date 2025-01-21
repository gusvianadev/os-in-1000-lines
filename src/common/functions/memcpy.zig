pub fn memcpy(dest: []u8, source: []u8, n: usize) void {
    var i: usize = 0;
    while (i < n) : (i += 1) dest[i] = source[i];
}

test memcpy {
    const std = @import("std");
    var source = [_]u8{ 1, 2, 3, 4, 5 };
    var dest = [_]u8{ 0, 0, 0, 0, 0 };

    memcpy(&dest, &source, 5);
    try std.testing.expectEqualSlices(u8, &source, &dest);
}
