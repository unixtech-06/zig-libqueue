const std = @import("std");

const Queue = @import("src/root.zig").Queue;

// Example usage and tests
pub fn main() !void {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var queue = Queue(i32, std.ArrayList(i32)).init(allocator);
        defer queue.deinit();

        try queue.push(1);
        try queue.push(2);
        try queue.push(3);

        std.debug.print("Front: {?}\n", .{queue.frontConst()});
        std.debug.print("Back: {?}\n", .{queue.backConst()});
        std.debug.print("Size: {}\n", .{queue.size()});
        std.debug.print("Is empty: {}\n", .{queue.empty()});

        queue.pop();
        std.debug.print("After pop, Front: {?}\n", .{queue.frontConst()});

        var queue2 = Queue(i32, std.ArrayList(i32)).init(allocator);
        defer queue2.deinit();

        try queue2.push(2);
        try queue2.push(3);

        std.debug.print("Queues equal: {}\n", .{eql(i32, std.ArrayList(i32), &queue, &queue2)});
        std.debug.print("queue < queue2: {}\n", .{lessThan(i32, std.ArrayList(i32), &queue, &queue2)});

        queue.swap(&queue2);
        std.debug.print("After swap, queue Front: {?}, queue2 Front: {?}\n", .{queue.frontConst(), queue2.frontConst()});

        // Test emplace
        const Point = struct {
                x: i32,
                y: i32,

                pub fn init(x: i32, y: i32) @This() {
                        return .{ .x = x, .y = y };
                }
        };

        var point_queue = Queue(Point, std.ArrayList(Point)).init(allocator);
        defer point_queue.deinit();

        try point_queue.emplace(.{10, 20});
        std.debug.print("Point: x={}, y={}\n", .{point_queue.frontConst().?.x, point_queue.frontConst().?.y});
}