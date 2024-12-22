const std = @import("std");

const xSize = 141;
const ySize = 141;
const maxCheat = 20;
const minDifferenceCheat = 100;

var startX: usize = 0;
var startY: usize = 0;

var endX: usize = 0;
var endY: usize = 0;

var counter: usize = 0;

var matrix: [ySize][xSize]i32 = undefined;

fn play(y: usize, x: usize, step: i32) void {
    switch (matrix[y][x]) {
        -3 => {
            matrix[y][x] = step;
        },
        -2 => {
            return;
        },
        -1 => matrix[y][x] = step,
        else => {
            if (matrix[y][x] > step) {
                matrix[y][x] = step;
            } else {
                return;
            }
        },
    }
    play(y, x - 1, step + 1);
    play(y - 1, x, step + 1);
    play(y + 1, x, step + 1);
    play(y, x + 1, step + 1);
}

fn checkCheats() void {
    const endValue = matrix[endY][endX];
    for (matrix, 0..) |r, y| {
        for (r, 0..) |c, x| {
            if (c == -2) {
                continue;
            } else {
                std.debug.print("{d}\n", .{matrix[y][x]});
                for (0..41) |i| {
                    const signed_i: i32 = @as(i32, @intCast(i)) - 20;
                    for (0..41) |j| {
                        const signed_j: i32 = @as(i32, @intCast(j)) - 20;
                        if (@abs(signed_i) + @abs(signed_j) > 20) {
                            continue;
                        }
                        const xInt: i32 = @intCast(x);
                        const yInt: i32 = @intCast(y);
                        if (yInt + signed_i < 0 or yInt + signed_i > ySize - 1 or xInt + signed_j < 0 or xInt + signed_j > xSize - 1) {
                            continue;
                        }
                        const valY: usize = @intCast(yInt + signed_i);
                        const valX: usize = @intCast(xInt + signed_j);
                        if (matrix[valY][valX] == -2) {
                            continue;
                        }

                        const dif: u32 = @intCast(endValue - matrix[valY][valX]);
                        const val: u32 = @intCast(matrix[y][x]);
                        if (dif + @abs(signed_i) + @abs(signed_j) + val <= endValue - minDifferenceCheat) {
                            counter += 1;
                        }
                    }
                }
            }
        }
    }
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

    play(startY, startX, 0);

    checkCheats();

    std.debug.print("\n\n{d}", .{counter});
}
