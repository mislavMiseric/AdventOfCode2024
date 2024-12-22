const std = @import("std");

const xSize = 141;
const ySize = 141;

var startX: usize = 0;
var startY: usize = 0;

var endX: usize = 0;
var endY: usize = 0;

var cheatX: usize = 0;
var cheatY: usize = 0;
var counter: usize = 0;

var matrix: [ySize][xSize]i32 = undefined;
var matrixResult: [ySize][xSize]i32 = undefined;

fn print2DArray(array: [ySize][xSize]i32) void {
    std.debug.print("000 001 002 003 004 005 006 007 008 009 010 011 012 013 014", .{});
    for (array, 0..) |r, i| {
        std.debug.print("\n", .{});
        for (r) |c| {
            if (c == -2 or c == -5) {
                std.debug.print("### ", .{});
            } else {
                std.debug.print("{:0>3} ", .{c});
            }
        }
        std.debug.print("{:0>3} ", .{i});
    }
}

fn play(y: usize, x: usize, step: i32, withoutCheats: bool, cheated: bool) bool {
    var cheatedMutable = cheated;
    switch (matrix[y][x]) {
        -5 => {
            return false;
        },
        -3 => {
            matrix[y][x] = step;
            return false;
        },
        -2 => {
            if (withoutCheats) {
                return false;
            }
            if (cheated) {
                return false;
            } else {
                matrix[y][x] = -5;
                cheatedMutable = true;
                cheatX = x;
                cheatY = y;
            }
        },
        -1 => matrix[y][x] = step,
        0 => {
            if (step != 0) {
                return false;
            }
            matrix[y][x] = 0;
        },
        else => {
            if (matrix[y][x] >= step) {
                matrix[y][x] = step;
                if (cheated and matrixResult[y][x] > 0) {
                    if (matrix[y][x] + 99 < matrixResult[y][x]) {
                        counter += 1;
                        return true;
                    }
                    return false;
                }
            } else {
                return false;
            }
        },
    }
    var returnBool = false;
    if (x > 0) {
        returnBool = play(y, x - 1, step + 1, withoutCheats, cheatedMutable);
    }
    if (y > 0) {
        returnBool = play(y - 1, x, step + 1, withoutCheats, cheatedMutable);
    }
    if (y < ySize - 1) {
        returnBool = play(y + 1, x, step + 1, withoutCheats, cheatedMutable);
    }
    if (x < xSize - 1) {
        returnBool = play(y, x + 1, step + 1, withoutCheats, cheatedMutable);
    }
    if (cheatedMutable and x == cheatX and y == cheatY) {
        @memcpy(&matrix, &matrixResult);
        if (returnBool) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    const file = try std.fs.cwd().openFile("resource/day20/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var rows: usize = 0;
    var cols: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        outer: for (line) |c| {
            for (std.ascii.whitespace) |other| {
                if (c == other)
                    continue :outer;
            }
            matrix[rows][cols] = switch (c) {
                '#' => -2,
                '.' => -1,
                'S' => blk: {
                    startX = cols;
                    startY = rows;
                    break :blk -1;
                },
                'E' => blk: {
                    endX = cols;
                    endY = rows;
                    break :blk -1;
                },
                else => -4,
            };
            cols += 1;
        }
        cols = 0;
        rows += 1;
    }

    var ret: bool = false;

    ret = play(startY, startX, 0, true, false);
    @memcpy(&matrixResult, &matrix);
    ret = play(startY, startX, 0, false, false);

    std.debug.print("{d} ", .{counter});
}
