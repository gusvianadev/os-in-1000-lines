const std = @import("std");
const putChar = @import("putChar.zig").putChar;

pub fn print(
    comptime fmt: []const u8,
    args: anytype,
) void {
    const ArgsType = @TypeOf(args);
    const field_names = comptime std.meta.fieldNames(ArgsType);

    comptime var fmt_i: usize = 0;
    comptime var args_i: usize = 0;

    inline while (fmt_i < fmt.len) : (fmt_i += 1) {
        if (fmt[fmt_i] != '{') {
            putChar(fmt[fmt_i]);
            continue;
        }
        fmt_i += 1;

        const placeholder = fmt[fmt_i];
        comptime var argument = @field(args, field_names[args_i]);
        args_i += 1;

        switch (placeholder) {
            's' => for (argument) |char| putChar(char),
            'd' => {
                if (argument < 0) {
                    putChar('-');
                    argument = -argument;
                }

                comptime var divisor = 1;

                inline while (argument / divisor > 9) divisor *= 10;
                inline while (divisor > 0) {
                    putChar('0' + argument / divisor);
                    argument %= divisor;
                    divisor /= 10;
                }
            },
            'x' => {
                comptime var i = 7;
                inline while (i >= 0) : (i -= 1) {
                    const nibble = (argument >> (i * 4) & 0xf);
                    putChar("0123456789abcdef"[nibble]);
                }
            },
            else => {},
        }
        fmt_i += 1;
    }
}
