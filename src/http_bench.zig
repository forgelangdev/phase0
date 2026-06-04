// FORGE Phase 0 — Demo 3: HTTP Server Performance
// Proves: Web serving at hardware speed, minimal memory footprint
// Goal: Show req/sec and memory usage vs Node.js / Go / Python

const std = @import("std");
const net = std.net;
const time = std.time;
const Thread = std.Thread;
const atomic = std.atomic;

const MAX_CONNECTIONS = 10_000;
const PORT = 8844;

var requests_served = atomic.Value(u64).init(0);
var bytes_sent = atomic.Value(u64).init(0);
var running = atomic.Value(bool).init(true);

const RESPONSE =
    "HTTP/1.1 200 OK\r\n" ++
    "Content-Type: text/plain\r\n" ++
    "Content-Length: 28\r\n" ++
    "Connection: close\r\n" ++
    "\r\n" ++
    "FORGE: Hardware-speed HTTP.\n";

fn handleConnection(conn: net.Server.Connection) void {
    defer conn.stream.close();
    var buf: [1024]u8 = undefined;
    _ = conn.stream.read(&buf) catch return;
    _ = conn.stream.writeAll(RESPONSE) catch return;
    _ = requests_served.fetchAdd(1, .monotonic);
    _ = bytes_sent.fetchAdd(RESPONSE.len, .monotonic);
}

fn serverThread(server: *net.Server) void {
    while (running.load(.acquire)) {
        const conn = server.accept() catch continue;
        const t = Thread.spawn(.{}, handleConnection, .{conn}) catch {
            conn.stream.close();
            continue;
        };
        t.detach();
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("\n╔══════════════════════════════════════════════════════════╗\n", .{});
    try stdout.print("║         FORGE Framework — HTTP Server Benchmark           ║\n", .{});
    try stdout.print("║              Zero-overhead web serving                    ║\n", .{});
    try stdout.print("╚══════════════════════════════════════════════════════════╝\n\n", .{});

    // Memory baseline
    const mem_before = getCurrentMemoryKB();

    var addr = net.Address.initIp4(.{ 127, 0, 0, 1 }, PORT);
    var server = try addr.listen(.{ .reuse_address = true });
    defer server.deinit();

    try stdout.print("  FORGE HTTP server started on port {d}\n", .{PORT});
    try stdout.print("  Listening for benchmark connections...\n\n", .{});

    // Start server in background thread
    const srv_thread = try Thread.spawn(.{}, serverThread, .{&server});
    _ = srv_thread;

    // Self-benchmark using HTTP client
    try stdout.print("[ BENCHMARK ] Sending 50,000 HTTP requests (self-test)\n\n", .{});

    const num_clients = 50;
    const req_per_client = 1000;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const threads = try allocator.alloc(Thread, num_clients);
    defer allocator.free(threads);

    const ClientCtx = struct {
        port: u16,
        count: usize,

        fn run(ctx: @This()) void {
            var i: usize = 0;
            while (i < ctx.count) : (i += 1) {
                const addr2 = net.Address.initIp4(.{ 127, 0, 0, 1 }, ctx.port);
                const stream = net.tcpConnectToAddress(addr2) catch continue;
                defer stream.close();
                _ = stream.writeAll("GET / HTTP/1.1\r\nHost: localhost\r\n\r\n") catch continue;
                var resp: [512]u8 = undefined;
                _ = stream.read(&resp) catch continue;
            }
        }
    };

    const t_start = time.nanoTimestamp();

    for (threads) |*t| {
        t.* = try Thread.spawn(.{}, ClientCtx.run, .{ClientCtx{ .port = PORT, .count = req_per_client }});
    }
    for (threads) |t| t.join();

    const t_end = time.nanoTimestamp();
    running.store(false, .release);

    const elapsed_ms = @as(f64, @floatFromInt(t_end - t_start)) / 1_000_000.0;
    const total_reqs = requests_served.load(.monotonic);
    const rps = @as(f64, @floatFromInt(total_reqs)) / (elapsed_ms / 1000.0);
    const mb_sent = @as(f64, @floatFromInt(bytes_sent.load(.monotonic))) / 1_048_576.0;
    const mem_after = getCurrentMemoryKB();
    const mem_used_kb = mem_after - mem_before;

    try stdout.print("  ✓ Requests served   : {d}\n", .{total_reqs});
    try stdout.print("  ✓ Time elapsed      : {d:.2} ms\n", .{elapsed_ms});
    try stdout.print("  ✓ Requests/second   : {d:.0}\n", .{rps});
    try stdout.print("  ✓ Data transferred  : {d:.2} MB\n", .{mb_sent});
    try stdout.print("  ✓ Memory used       : {d} KB\n\n", .{mem_used_kb});

    try stdout.print("╔══════════════════════════════════════════════════════════╗\n", .{});
    try stdout.print("║              FORGE vs FRAMEWORKS — HTTP                  ║\n", .{});
    try stdout.print("╠══════════════════════════════════════════════════════════╣\n", .{});
    try stdout.print("║  Framework     Req/sec (est)    Memory                  ║\n", .{});
    try stdout.print("║  ─────────     ─────────────    ──────                  ║\n", .{});
    try stdout.print("║  Python Flask  ~1,000           ~45 MB                  ║\n", .{});
    try stdout.print("║  Node.js       ~15,000          ~35 MB                  ║\n", .{});
    try stdout.print("║  Go net/http   ~50,000          ~8 MB                   ║\n", .{});
    try stdout.print("║  Rust actix    ~120,000         ~3 MB                   ║\n", .{});
    try stdout.writeAll("║  FORGE         ");
    try stdout.print("{d:>10.0}    {d:>4} KB (THIS SERVER)    ║\n", .{ rps, mem_used_kb });
    try stdout.print("╚══════════════════════════════════════════════════════════╝\n\n", .{});
    try stdout.print("  forge.dev | github.com/forgelangdev/phase0 | @forgelang_dev\n\n", .{});
}

fn getCurrentMemoryKB() u64 {
    const file = std.fs.openFileAbsolute("/proc/self/status", .{}) catch return 0;
    defer file.close();
    var buf: [4096]u8 = undefined;
    const n = file.read(&buf) catch return 0;
    const content = buf[0..n];
    var lines = std.mem.splitSequence(u8, content, "\n");
    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, "VmRSS:")) {
            var parts = std.mem.tokenizeAny(u8, line, " \t");
            _ = parts.next(); // "VmRSS:"
            if (parts.next()) |val| {
                return std.fmt.parseInt(u64, val, 10) catch 0;
            }
        }
    }
    return 0;
}
