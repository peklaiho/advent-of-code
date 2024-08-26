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

        var is_valid = true;

        const colon = std.mem.indexOf(u8, line, ":").?;
        const game_num = try std.fmt.parseInt(u8, line[5 .. colon], 10);

        // std.debug.print("Game {d}\n", .{ game_num });

        var sets = std.mem.splitScalar(u8, line[(colon + 1) ..], ';');

        while (sets.next()) |set| {
            // std.debug.print("Set {s}\n", .{ set });

            var colors = std.mem.splitScalar(u8, set, ',');

            while (colors.next()) |num_and_color| {
                const space = std.mem.indexOfPos(u8, num_and_color, 1, " ").?;
                const num = try std.fmt.parseInt(u8, num_and_color[1 .. space], 10);
                const color = num_and_color[(space + 1) ..];

                if ((num > 12 and std.mem.eql(u8, color, "red")) or
                        (num > 13 and std.mem.eql(u8, color, "green")) or
                        (num > 14 and std.mem.eql(u8, color, "blue"))) {
                    is_valid = false;
                    break;
                }
            }

            if (!is_valid) {
                break;
            }
        }

        if (is_valid) {
            total += game_num;
        }
    }

    std.debug.print("Part 1: {d}\n", .{total});
}

pub fn main() !void {
    const data = try common.readInputFile("day02-input.txt", allocator);

    try partOne(data);
    // try partTwo(data);
}
