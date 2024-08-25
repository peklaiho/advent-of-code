const std = @import("std");
const common = @import("./common.zig");

fn makeValue(first: ?u8, last: ?u8) !void {
    if (first) |tens| {
        if (last) |ones| {
            return (tens * 10) + ones;
        }
    }

    return error.MissingValue;
}

fn partOne(data: []const u8) !void {
    var lines = std.mem.splitScalar(u8, data, '\n');

    var total: u32 = 0;

    while (lines.next()) |line| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        const first = common.firstDigit(line);
        const last = common.lastDigit(line);

        total += try makeValue(first, last);
    }

    std.debug.print("Part 1: {d}\n", .{total});
}

fn partTwo(data: []const u8) !void {
    var lines = std.mem.splitScalar(u8, data, '\n');

    // var total: u32 = 0;

    while (lines.next()) |line| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        const first = common.firstDigitWord(line);
        const last = common.lastDigitWord(line);

        std.debug.print("{s} {d} {d}\n", .{line, first.?, last.?});

        // total += (first * 10);
    }

    // std.debug.print("Part 2: {d}\n", .{total});
}

pub fn main() !void {
    const data = try common.readInputFile("day01-example2.txt");

    // try partOne(data);
    try partTwo(data);
}
