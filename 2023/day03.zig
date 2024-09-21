const std = @import("std");
const common = @import("./common.zig");

const Number = struct {
    val: u32,
    index: usize,
    len: u8
};

fn readNextNumber(line: []const u8, startIndex: usize) ?Number {
    var result: ?Number = null;
    var index: usize = startIndex;

    while (index < line.len) {
        const c = line[index];

        if (c >= '0' and c <= '9') {
            if (result) |res| {
                res.val *= 10;
                res.val += c - '0';
                res.len += 1;
            } else {
                result = Number{
                    .val = c - '0',
                    .index = index,
                    .len = 1,
                };
            }
        } else if (result) {
            return result;
        }

        index += 1;
    }

    return result;
}

fn lineSum(line: []const u8, previous: ?[]const u8, next: ?[]const u8) u32 {
    var index: usize = 0;

    while (index < line.len) {
        var number = readNextNumber(
    }

    return 0;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const data = try common.readInputFile("day03-example.txt", allocator);
    const lines = try common.splitIntoLines(data, allocator);

    var total: u32 = 0;

    for (lines, 0..) |line, i| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        // Previous and next lines
        const previous: ?[]const u8 = null;
        const next: ?[]const u8 = null;
        if (i > 0) {
            previous = lines[i - 1];
        }
        if (i < lines.len - 1) {
            next = lines[i + 1];
        }

        total += lineSum(line, previous, next);
    }

    std.debug.print("Part 1: {d}\n", .{total});
}
