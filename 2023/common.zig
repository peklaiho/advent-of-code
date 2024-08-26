const std = @import("std");

/// Read file and allocate space for it.
pub fn readInputFile(filename: []const u8, allocator: std.mem.Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const data = try file.readToEndAlloc(allocator, 1024 * 1024);
    return data;
}

/// Read first digit ('0', '1', ...) from string and convert it to integer.
pub fn firstDigit(str: []const u8) !u8 {
    for (str) |c| {
        if (c >= '0' and c <= '9') {
            return c - '0';
        }
    }

    return error.DigitNotFound;
}

/// Read last digit ('0', '1', ...) from string and convert it to integer.
pub fn lastDigit(str: []const u8) !u8 {
    var i = str.len;

    while (i > 0) {
        i -= 1;
        if (str[i] >= '0' and str[i] <= '9') {
            return str[i] - '0';
        }
    }

    return error.DigitNotFound;
}

const digitWords = [9][]const u8 {
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
pub fn firstDigitWord(str: []const u8) !u8 {
    var i: usize = 0;

    while (i < str.len) {
        if (str[i] >= '0' and str[i] <= '9') {
            return str[i] - '0';
        }

        for (digitWords, 0..) |word, word_index| {
            const end = i + word.len;
            if (end <= str.len and std.mem.eql(u8, str[i .. end], word)) {
                return @intCast(word_index + 1);
            }
        }

        i += 1;
    }

    return error.DigitNotFound;
}

/// Same as lastDigit, but include words ("one", "two", ...).
pub fn lastDigitWord(str: []const u8) !u8 {
    var i = str.len;

    while (i > 0) {
        i -= 1;

        if (str[i] >= '0' and str[i] <= '9') {
            return str[i] - '0';
        }

        for (digitWords, 0..) |word, word_index| {
            const end = i + word.len;
            if (end <= str.len and std.mem.eql(u8, str[i .. end], word)) {
                return @intCast(word_index + 1);
            }
        }
    }

    return error.DigitNotFound;
}
