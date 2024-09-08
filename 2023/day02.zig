const std = @import("std");
const common = @import("./common.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const data = try common.readInputFile("day02-input.txt", allocator);

    var lines = std.mem.splitScalar(u8, data, '\n');

    var total1: u32 = 0;
    var total2: u32 = 0;

    while (lines.next()) |line| {
        // Skip over empty lines
        if (line.len == 0) {
            continue;
        }

        var is_valid = true;

        const colon = std.mem.indexOf(u8, line, ":").?;
        const game_num = try std.fmt.parseInt(u8, line[5 .. colon], 10);

        var sets = std.mem.splitScalar(u8, line[(colon + 1) ..], ';');

        var max_red: u32 = 0;
        var max_green: u32 = 0;
        var max_blue: u32 = 0;

        while (sets.next()) |set| {
            var colors = std.mem.splitScalar(u8, set, ',');

            while (colors.next()) |num_and_color| {
                const space = std.mem.indexOfPos(u8, num_and_color, 1, " ").?;
                const num = try std.fmt.parseInt(u8, num_and_color[1 .. space], 10);
                const color = num_and_color[(space + 1) ..];

                if (std.mem.eql(u8, color, "red")) {
                    if (num > 12) {
                        is_valid = false;
                    }
                    if (num > max_red) {
                        max_red = num;
                    }
                } else if (std.mem.eql(u8, color, "green")) {
                    if (num > 13) {
                        is_valid = false;
                    }
                    if (num > max_green) {
                        max_green = num;
                    }
                } else if (std.mem.eql(u8, color, "blue")) {
                    if (num > 14) {
                        is_valid = false;
                    }
                    if (num > max_blue) {
                        max_blue = num;
                    }
                } else {
                    // Unknown color, should not happen
                }
            }
        }

        if (is_valid) {
            total1 += game_num;
        }

        total2 += max_red * max_green * max_blue;
    }

    std.debug.print("Part 1: {d}\n", .{total1});
    std.debug.print("Part 2: {d}\n", .{total2});
}
