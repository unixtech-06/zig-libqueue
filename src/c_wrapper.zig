const std = @import("std");
const Allocator = std.mem.Allocator;

const Queue = @import("./root.zig");

// C API
pub export fn queue_init() ?*Queue.Queue(i32, std.ArrayList(i32)) {
        const queue = std.heap.c_allocator.create(Queue.Queue(i32, std.ArrayList(i32))) catch return null;
        queue.* = Queue.Queue(i32, std.ArrayList(i32)).init(std.heap.c_allocator);
        return queue;
}

pub export fn queue_deinit(queue: ?*Queue.Queue(i32, std.ArrayList(i32))) void {
        if (queue) |q| {
                q.deinit();
                std.heap.c_allocator.destroy(q);
        }
}

pub export fn queue_front(queue: ?*Queue.Queue(i32, std.ArrayList(i32))) ?*i32 {
        return if (queue) |q| q.front() else null;
}

pub export fn queue_front_const(queue: ?*const Queue.Queue(i32, std.ArrayList(i32))) i32 {
        return if (queue) |q| q.frontConst() orelse 0 else 0;
}

pub export fn queue_back(queue: ?*Queue.Queue(i32, std.ArrayList(i32))) ?*i32 {
        return if (queue) |q| q.back() else null;
}

pub export fn queue_back_const(queue: ?*const Queue.Queue(i32, std.ArrayList(i32))) i32 {
        return if (queue) |q| q.backConst() orelse 0 else 0;
}

pub export fn queue_empty(queue: ?*const Queue.Queue(i32, std.ArrayList(i32))) bool {
        return if (queue) |q| q.empty() else true;
}

pub export fn queue_size(queue: ?*const Queue.Queue(i32, std.ArrayList(i32))) usize {
        return if (queue) |q| q.size() else 0;
}

pub export fn queue_push(queue: ?*Queue.Queue(i32, std.ArrayList(i32)), value: i32) bool {
        if (queue) |q| {
                q.push(value) catch return false;
                return true;
        }
        return false;
}

pub export fn queue_pop(queue: ?*Queue.Queue(i32, std.ArrayList(i32))) void {
        if (queue) |q| q.pop();
}

pub export fn queue_swap(queue1: ?*Queue.Queue(i32, std.ArrayList(i32)), queue2: ?*Queue.Queue(i32, std.ArrayList(i32))) void {
        if (queue1 != null and queue2 != null) {
                queue1.?.swap(queue2.?);
        }
}

pub export fn queue_at(queue: ?*const Queue.Queue(i32, std.ArrayList(i32)), index: usize) i32 {
        return if (queue) |q| q.at(index) orelse 0 else 0;
}

pub export fn queue_equal(queue1: ?*const Queue.Queue(i32, std.ArrayList(i32)), queue2: ?*const Queue.Queue(i32, std.ArrayList(i32))) bool {
        return if (queue1 != null and queue2 != null) Queue.eql(i32, std.ArrayList(i32), queue1.?, queue2.?) else false;
}

pub export fn queue_less_than(queue1: ?*const Queue.Queue(i32, std.ArrayList(i32)), queue2: ?*const Queue.Queue(i32, std.ArrayList(i32))) bool {
        return if (queue1 != null and queue2 != null) Queue.lessThan(i32, std.ArrayList(i32), queue1.?, queue2.?) else false;
}

pub export fn queue_less_than_or_equal(queue1: ?*const Queue.Queue(i32, std.ArrayList(i32)), queue2: ?*const Queue.Queue(i32, std.ArrayList(i32))) bool {
        return if (queue1 != null and queue2 != null) Queue.lessThanOrEqual(i32, std.ArrayList(i32), queue1.?, queue2.?) else false;
}

pub export fn queue_greater_than(queue1: ?*const Queue.Queue(i32, std.ArrayList(i32)), queue2: ?*const Queue.Queue(i32, std.ArrayList(i32))) bool {
        return if (queue1 != null and queue2 != null) Queue.greaterThan(i32, std.ArrayList(i32), queue1.?, queue2.?) else false;
}

pub export fn queue_greater_than_or_equal(queue1: ?*const Queue.Queue(i32, std.ArrayList(i32)), queue2: ?*const Queue.Queue(i32, std.ArrayList(i32))) bool {
        return if (queue1 != null and queue2 != null) Queue.greaterThanOrEqual(i32, std.ArrayList(i32), queue1.?, queue2.?) else false;
}