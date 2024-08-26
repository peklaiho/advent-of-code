const std = @import("std");
const common = @import("./common.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn partOne(data: []const u8) !void {
    var lines = std.mem.splitScalar(u8, data, '\n');

    var total: u32 = 0;

    while (lines.next()) |line| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        const first = try common.firstDigit(line);
        const last = try common.lastDigit(line);

        total += (first * 10) + last;
    }

    std.debug.print("Part 1: {d}\n", .{total});
}

fn partTwo(data: []const u8) !void {
    var lines = std.mem.splitScalar(u8, data, '\n');

    var total: u32 = 0;

    while (lines.next()) |line| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        const first = try common.firstDigitWord(line);
        const last = try common.lastDigitWord(line);

        total += (first * 10) + last;
    }

    std.debug.print("Part 2: {d}\n", .{total});
}

pub fn main() !void {
    const data = try common.readInputFile("day01-input.txt", allocator);

    try partOne(data);
    try partTwo(data);
}
