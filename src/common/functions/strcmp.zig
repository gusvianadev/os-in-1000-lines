pub fn strcmp(s1: []const u8, s2: []const u8) bool {
    // Different lengths
    if (s1.len != s2.len) return false;

    // Char by char
    return for (s1, s2) |c1, c2| {
        if (c1 != c2) break false;
    } else true;
}

test strcmp {
    const std = @import("std");

    try std.testing.expect(strcmp("abc", "abc") == true);
    try std.testing.expect(strcmp("ab", "abc") == false);
    try std.testing.expect(strcmp("abf", "abc") == false);
    try std.testing.expect(strcmp("", "") == true);
}
