const std = @import("std");

// Do not worry about freeing memory for now
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

/// Read file and allocate space for it.
pub fn readInputFile(filename: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const filedata = try file.readToEndAlloc(allocator, 1024 * 1024);
    return filedata;
}

/// Read first digit from string and convert it to integer.
/// Return NoDigitFound error if no digit is found.
pub fn firstDigit(str: []const u8) !u8 {
    for (str) |c| {
        if (c >= '0' and c <= '9') {
            return c - 48;
        }
    }

    return error.NoDigitFound;
}

/// Read last digit from string and convert it to integer.
/// Return NoDigitFound error if no digit is found.
pub fn lastDigit(str: []const u8) !u8 {
    var i = str.len - 1;

    while (i >= 0) {
        if (str[i] >= '0' and str[i] <= '9') {
            return str[i] - 48;
        }
        i -= 1;
    }

    return error.NoDigitFound;
}
