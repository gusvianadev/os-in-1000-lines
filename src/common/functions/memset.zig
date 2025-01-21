pub fn memset(buf: []u8, value: u8) void {
    var i: usize = 0;
    while (i < buf.len) : (i += 1) buf[i] = value;
}

test memset {
    const std = @import("std");
    var buf = [_]u8{ 1, 2, 3, 4, 5 };
    const expected = [_]u8{ 0, 0, 0, 0, 0 };

    memset(&buf, 0);
    try std.testing.expectEqualSlices(u8, &expected, &buf);
}
