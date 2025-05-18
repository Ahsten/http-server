const std = @import("std");
const SocketConfig = @import("config.zig");
const stdout = std.io.getStdOut().writer();
const Request = @import("request.zig");

pub fn main() !void {
    const socket = try SocketConfig.Socket.init();
    try stdout.print("Server address: {any}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    const connection = try server.accept();
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }

    try Request.read_request(connection, buffer[0..buffer.len]);
    const request = Request.parse_request(buffer[0..buffer.len]);
    try stdout.print("Method: {any}\n", .{request.method});
    try stdout.print("Version: {s}\n", .{request.version});
    try stdout.print("URI: {s}\n", .{request.uri});
}
