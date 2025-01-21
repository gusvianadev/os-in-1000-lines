const std = @import("std");
const putChar = @import("putChar.zig").putChar;

pub fn print_runtime(
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
        var argument = @field(args, field_names[args_i]);
        args_i += 1;

        switch (placeholder) {
            's' => for (argument) |char| putChar(char),
            'd' => {
                if (argument < 0) {
                    putChar('-');
                    argument = -argument;
                }

                var divisor: u32 = 1;

                while (argument / divisor > 9) divisor *= 10;
                while (divisor > 0) {
                    const number: u8 = @intCast(argument / divisor);
                    putChar('0' + number);
                    argument %= divisor;
                    divisor /= 10;
                }
            },
            'x' => {
                var i: u5 = 8;
                while (i >= 1) : (i -= 1) {
                    const nibble = (argument >> ((i - 1) * 4) & 0xf);
                    putChar("0123456789abcdef"[nibble]);
                }
            },
            else => {},
        }
        fmt_i += 1;
    }
}
