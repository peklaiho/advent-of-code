const std = @import("std");
const common = @import("./common.zig");

const Number = struct {
    val: i32,
    index: i32,
    len: i32
};

// Printf debugging for the win?
const debug_mode = false;

fn readNextNumber(line: []const u8, startIndex: i32) ?Number {
    if (debug_mode) {
        std.debug.print("Search for next number from index {d} on line: {s}\n", .{startIndex, line});
    }

    var result: ?Number = null;
    var index = startIndex;

    while (index < line.len) {
        const c = line[@intCast(index)];

        if (c >= '0' and c <= '9') {
            if (result) |*res| {
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
        } else if (result) |res| {
            return res;
        }

        index += 1;
    }

    return result;
}

fn hasSymbol(line: []const u8, start: i32, end: i32) bool {
    var index = start;

    while (index < end and index < line.len) {
        // Skip over indexes before 0
        if (index < 0) {
            index += 1;
            continue;
        }

        const c = line[@intCast(index)];

        if (c != '.' and (c < '0' or c > '9')) {
            if (debug_mode) {
                std.debug.print("Line {s} has symbol {c} at index {d} in range [{d} {d}].\n", .{line, c, index, start, end - 1});
            }
            return true;
        } else {
            index += 1;
        }
    }

    if (debug_mode) {
        std.debug.print("Line {s} does not have symbols in range [{d} {d}].\n", .{line, start, end - 1});
    }
    return false;
}

fn hasConnectedSymbol(number: Number, line: []const u8, previous: ?[]const u8, next: ?[]const u8) bool {
    if (debug_mode) {
        std.debug.print("Check if number {d} (index {d}, len {d}) has connected symbol.\n", .{number.val, number.index, number.len});
    }

    // Current line
    if (hasSymbol(line, number.index - 1, number.index) or
            hasSymbol(line, number.index + number.len, number.index + number.len + 1)) {
        return true;
    }

    // Previous line
    if (previous) |prev| {
        if (hasSymbol(prev, number.index - 1, number.index + number.len + 1)) {
            return true;
        }
    }

    // Next line
    if (next) |nxt| {
        if (hasSymbol(nxt, number.index - 1, number.index + number.len + 1)) {
            return true;
        }
    }

    return false;
}

fn lineSum(line: []const u8, previous: ?[]const u8, next: ?[]const u8) i32 {
    var index: i32 = 0;
    var total: i32 = 0;

    while (index < line.len) {
        const number = readNextNumber(line, index);

        if (number) |num| {
            if (debug_mode) {
                std.debug.print("Found number {d} (index {d}, len {d}) on line: {s}\n", .{num.val, num.index, num.len, line});
            }

            index = num.index + num.len + 1;

            if (hasConnectedSymbol(num, line, previous, next)) {
                total += num.val;
                if (debug_mode) {
                    std.debug.print("Number {d} has connected symbol.\n\n", .{num.val});
                }
            } else {
                if (debug_mode) {
                    std.debug.print("Number {d} does not have connected symbol.\n\n", .{num.val});
                }
            }
        } else {
            break;
        }
    }

    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const data = try common.readInputFile("day03-input.txt", allocator);
    const lines = try common.splitIntoLines(data, allocator);

    var total: i32 = 0;

    for (lines, 0..) |line, i| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        // Previous and next lines
        const previous: ?[]const u8 = if (i > 0) lines[i - 1] else null;
        const next: ?[]const u8 = if (i < lines.len - 1) lines[i + 1] else null;

        total += lineSum(line, previous, next);
    }

    std.debug.print("Part 1: {d}\n", .{total});
}
