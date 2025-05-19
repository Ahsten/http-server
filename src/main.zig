const std = @import("std");
const SocketConfig = @import("config.zig");
const stdout = std.io.getStdOut().writer();
const Request = @import("request.zig");
const Method = @import("request.zig").Method;
const Response = @import("response.zig");

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
    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection);
        } else {
            try Response.send_400(connection);
        }
    }
}
