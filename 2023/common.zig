const std = @import("std");

// Do not worry about freeing memory for now
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

/// Read file and allocate space for it.
pub fn readInputFile(filename: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const data = try file.readToEndAlloc(allocator, 1024 * 1024);
    return data;
}

const FindDigitResult = {
    index: usize,
    value: u8
};

/// Read first digit ('0', '1', ...) from string and convert it to integer.
pub fn firstDigit(str: []const u8) ?FindDigitResult {
    for (str, 0..) |c, i| {
        if (c >= '0' and c <= '9') {
            return FindDigitResult{
                .index = i,
                .value = c - '0',
            };
        }
    }

    return null;
}

/// Read last digit ('0', '1', ...) from string and convert it to integer.
pub fn lastDigit(str: []const u8) ?FindDigitResult {
    var i = str.len;

    while (i > 0) {
        i -= 1;
        if (str[i] >= '0' and str[i] <= '9') {
            return FindDigitResult{
                .index = i,
                .value = str[i] - '0',
            };
        }
    }

    return null;
}

const digitWords: [9][]const u8 = .{
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
};

/// Same as firstDigit, but include words ("one", "two", ...).
pub fn firstDigitWord(str: []const u8) ?FindDigitResult {
    var result = firstDigit(str);

    for (digitWords, 0..) |word, num| {
        const res = std.mem.indexOf(u8, str, word);
        if (res) |i| {
            if (result == null or i < result.?.index)
            if (index < 0 or i < index) {
                index = @intCast(i);
                value = @intCast(num + 1);
            }
        }
    }

    return if (index >= 0) value else null;
}

/// Same as lastDigit, but include words ("one", "two", ...).
pub fn lastDigitWord(str: []const u8) ?u8 {
    var index: i32 = -1;
    var value: u8 = 0;

    for (digitWords, 0..) |word, num| {
        const res = std.mem.lastIndexOf(u8, str, word);
        if (res) |i| {
            if (index < 0 or i > index) {
                index = @intCast(i);
                value = @intCast(num + 1);
            }
        }
    }

    return if (index >= 0) value else null;
}
