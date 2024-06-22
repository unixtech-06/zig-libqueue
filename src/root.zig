const std = @import("std");
const expect = std.testing.expect;

pub fn Queue(comptime T: type, comptime Container: type) type {
        return struct {
                const Self = @This();
                c: Container, // underlying container

                // Constructor
                pub fn init(allocator: std.mem.Allocator) Self {
                        return Self{
                                .c = switch (@typeInfo(Container)) {
                                        .Struct => Container.init(allocator),
                                        else => @compileError("Container must be a struct with init(allocator) method"),
                                },
                        };
                }

                // Destructor
                pub fn deinit(self: *Self) void {
                        self.c.deinit();
                }

                // Element access

                // Returns a reference to the first element
                pub fn front(self: *Self) ?*T {
                        if (self.c.items.len == 0) return null;
                        return &self.c.items[0];
                }

                // Returns a const reference to the first element
                pub fn frontConst(self: *const Self) ?T {
                        if (self.c.items.len == 0) return null;
                        return self.c.items[0];
                }

                // Returns a reference to the last element
                pub fn back(self: *Self) ?*T {
                        if (self.c.items.len == 0) return null;
                        return &self.c.items[self.c.items.len - 1];
                }

                // Returns a const reference to the last element
                pub fn backConst(self: *const Self) ?T {
                        if (self.c.items.len == 0) return null;
                        return self.c.items[self.c.items.len - 1];
                }

                // Capacity

                // Checks whether the underlying container is empty
                pub fn empty(self: *const Self) bool {
                        return self.c.items.len == 0;
                }

                // Returns the number of elements
                pub fn size(self: *const Self) usize {
                        return self.c.items.len;
                }

                // Modifiers

                // Inserts element at the end
                pub fn push(self: *Self, value: T) !void {
                        try self.c.append(value);
                }

                // Removes the first element
                pub fn pop(self: *Self) void {
                        if (self.c.items.len > 0) {
                                _ = self.c.orderedRemove(0);
                        }
                }

                // Swaps the contents
                pub fn swap(self: *Self, other: *Self) void {
                        std.mem.swap(Container, &self.c, &other.c);
                }

                // Emplace (C++17)
                // In Zig, we can't directly implement emplace as in C++, but we can provide a similar functionality
                pub fn emplace(self: *Self, args: anytype) !void {
                        const value = try self.c.addOne();
                        value.* = @call(.auto, T.init, args);
                }

                // Non-member functions

                // Lexicographically compares the values in the queue
                pub fn isEqual(self: *const Self, other: *const Self) bool {
                        if (self.c.items.len != other.c.items.len) return false;
                        for (self.c.items, other.c.items) |a, b| {
                                if (a != b) return false;
                        }
                        return true;
                }

                pub fn isLessThan(self: *const Self, other: *const Self) bool {
                        const min_len = @min(self.c.items.len, other.c.items.len);
                        var i: usize = 0;
                        while (i < min_len) : (i += 1) {
                                if (self.c.items[i] < other.c.items[i]) return true;
                                if (self.c.items[i] > other.c.items[i]) return false;
                        }
                        return self.c.items.len < other.c.items.len;
                }

                pub fn isLessThanOrEqual(self: *const Self, other: *const Self) bool {
                        return lessThan(T, Container, self, other) or eql(T, Container, self, other);
                }

                pub fn isGreaterThan(self: *const Self, other: *const Self) bool {
                        return lessThan(T, Container, other, self);
                }

                pub fn isGreaterThanOrEqual(self: *const Self, other: *const Self) bool {
                        return greaterThan(T, Container, self, other) or eql(T, Container, self, other);
                }

                pub fn at(self: *const Self, index: usize) ?T {
                        if (index >= self.c.items.len) {
                                return null;
                        }
                        return self.c.items[index];
                }

                pub fn underlying(self: *const Self) *const Container {
                        return &self.c;
                }
        };
}

// Helper functions to mimic C++ global operators
pub fn eql(comptime T: type, comptime Container: type, a: *const Queue(T, Container), b: *const Queue(T, Container)) bool {
        return a.isEqual(b);
}

pub fn lessThan(comptime T: type, comptime Container: type, a: *const Queue(T, Container), b: *const Queue(T, Container)) bool {
        return a.isLessThan(b);
}

pub fn lessThanOrEqual(comptime T: type, comptime Container: type, a: *const Queue(T, Container), b: *const Queue(T, Container)) bool {
        return a.isLessThanOrEqual(b);
}

pub fn greaterThan(comptime T: type, comptime Container: type, a: *const Queue(T, Container), b: *const Queue(T, Container)) bool {
        return a.isGreaterThan(b);
}

pub fn greaterThanOrEqual(comptime T: type, comptime Container: type, a: *const Queue(T, Container), b: *const Queue(T, Container)) bool {
        return a.isGreaterThanOrEqual(b);
}

test "Queue comparison functions" {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        var queue1 = Queue(i32, std.ArrayList(i32)).init(allocator);
        defer queue1.deinit();

        var queue2 = Queue(i32, std.ArrayList(i32)).init(allocator);
        defer queue2.deinit();

        var queue3 = Queue(i32, std.ArrayList(i32)).init(allocator);
        defer queue3.deinit();

        // Test empty queues
        try expect(eql(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(!lessThan(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(lessThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue2));

        // Add elements to queue1 and queue2
        try queue1.push(1);
        try queue1.push(2);
        try queue1.push(3);

        try queue2.push(1);
        try queue2.push(2);
        try queue2.push(3);

        // Test equal queues
        try expect(eql(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(!lessThan(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(lessThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(!greaterThan(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(greaterThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue2));

        // Modify queue2 to be greater than queue1
        try queue2.push(4);

        try expect(!eql(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(lessThan(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(lessThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(!greaterThan(i32, std.ArrayList(i32), &queue1, &queue2));
        try expect(!greaterThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue2));

        // Test with queue3 having same length as queue1 but different elements
        try queue3.push(1);
        try queue3.push(2);
        try queue3.push(4);

        try expect(!eql(i32, std.ArrayList(i32), &queue1, &queue3));
        try expect(lessThan(i32, std.ArrayList(i32), &queue1, &queue3));
        try expect(lessThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue3));
        try expect(!greaterThan(i32, std.ArrayList(i32), &queue1, &queue3));
        try expect(!greaterThanOrEqual(i32, std.ArrayList(i32), &queue1, &queue3));
}