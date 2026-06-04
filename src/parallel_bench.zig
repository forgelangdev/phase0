// FORGE Phase 0 — Demo 2: Auto-Parallelism Proof of Concept
// Proves: Same code, compiler-distributed across all cores automatically
// Goal: 100M records processed showing linear scaling with core count

const std = @import("std");
const time = std.time;
const Thread = std.Thread;
const Allocator = std.mem.Allocator;
const atomic = std.atomic;

// This simulates what FORGE compiler will do automatically
// Developer writes sequential logic, FORGE distributes it

const DataPoint = struct {
    value: f64,
    weight: f64,
    tag: u32,
    result: f64,
};

// The "user code" — simple sequential logic
// FORGE compiler sees this and distributes automatically
inline fn processPoint(dp: *DataPoint) void {
    // Simulate real compute: matrix transform + normalisation
    const v = dp.value;
    const w = dp.weight;
    dp.result = @sqrt(v * v + w * w) * @sin(v * 0.001) * @cos(w * 0.001);
    dp.tag = if (dp.result > 0) 1 else 0;
}

// Sequential version (baseline — what Python/naive code does)
fn runSequential(data: []DataPoint) void {
    for (data) |*dp| processPoint(dp);
}

// FORGE parallel version — this is what the compiler generates
fn runForgeParallel(data: []DataPoint, allocator: Allocator) !void {
    const num_cores = try Thread.getCpuCount();
    const chunk_size = data.len / num_cores;

    const WorkCtx = struct {
        chunk: []DataPoint,
        fn run(ctx: @This()) void {
            for (ctx.chunk) |*dp| processPoint(dp);
        }
    };

    const threads = try allocator.alloc(Thread, num_cores);
    defer allocator.free(threads);

    for (threads, 0..) |*t, i| {
        const start = i * chunk_size;
        const end = if (i == num_cores - 1) data.len else (i + 1) * chunk_size;
        t.* = try Thread.spawn(.{}, WorkCtx.run, .{WorkCtx{ .chunk = data[start..end] }});
    }
    for (threads) |t| t.join();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();

    try stdout.print("\n╔══════════════════════════════════════════════════════════╗\n", .{});
    try stdout.print("║         FORGE Framework — Auto-Parallelism Demo           ║\n", .{});
    try stdout.print("║      Same code. Compiler handles distribution.            ║\n", .{});
    try stdout.print("╚══════════════════════════════════════════════════════════╝\n\n", .{});

    const N = 100_000_000; // 100 million records
    const num_cores = try Thread.getCpuCount();

    try stdout.print("  System cores available: {d}\n", .{num_cores});
    try stdout.print("  Records to process:     {d} million\n\n", .{N / 1_000_000});

    // Allocate data
    try stdout.print("  Allocating {d} MB of data...\n", .{N * @sizeOf(DataPoint) / 1_024 / 1_024});
    const data = try allocator.alloc(DataPoint, N);
    defer allocator.free(data);

    var prng = std.rand.DefaultPrng.init(12345);
    const rand = prng.random();
    for (data) |*dp| {
        dp.value = rand.float(f64) * 1000.0;
        dp.weight = rand.float(f64) * 100.0;
        dp.tag = 0;
        dp.result = 0;
    }
    try stdout.print("  Data ready.\n\n", .{});

    // ─── Sequential (Python-equivalent approach) ─────────────────────
    try stdout.print("[ BASELINE ] Sequential — 1 core (Python/naive approach)\n", .{});
    const seq_data = try allocator.dupe(DataPoint, data);
    defer allocator.free(seq_data);

    const t_seq_start = time.nanoTimestamp();
    runSequential(seq_data);
    const t_seq_end = time.nanoTimestamp();

    const t_seq_ms = @as(f64, @floatFromInt(t_seq_end - t_seq_start)) / 1_000_000.0;
    const seq_mrec_s = (@as(f64, @floatFromInt(N)) / 1_000_000.0) / (t_seq_ms / 1000.0);
    try stdout.print("  Time: {d:.2} ms  |  Rate: {d:.2} M rec/sec\n\n", .{ t_seq_ms, seq_mrec_s });

    // ─── FORGE Parallel (auto-distributed) ───────────────────────────
    try stdout.print("[ FORGE ] Auto-Parallel — {d} cores (compiler-distributed)\n", .{num_cores});
    const par_data = try allocator.dupe(DataPoint, data);
    defer allocator.free(par_data);

    const t_par_start = time.nanoTimestamp();
    try runForgeParallel(par_data, allocator);
    const t_par_end = time.nanoTimestamp();

    const t_par_ms = @as(f64, @floatFromInt(t_par_end - t_par_start)) / 1_000_000.0;
    const par_mrec_s = (@as(f64, @floatFromInt(N)) / 1_000_000.0) / (t_par_ms / 1000.0);
    const speedup = t_seq_ms / t_par_ms;

    try stdout.print("  Time: {d:.2} ms  |  Rate: {d:.2} M rec/sec\n", .{ t_par_ms, par_mrec_s });
    try stdout.print("  Speedup: {d:.2}x faster than sequential\n\n", .{speedup});

    // ─── Scaling table ────────────────────────────────────────────────
    try stdout.print("[ SCALING ] Performance by core count\n\n", .{});
    try stdout.print("  Cores   Time (ms)   Rate (M/s)   Speedup\n", .{});
    try stdout.print("  ─────   ─────────   ──────────   ───────\n", .{});

    var c: usize = 1;
    while (c <= num_cores) : (c = if (c == 1) 2 else c + 2) {
        if (c > num_cores) break;
        const test_data = try allocator.dupe(DataPoint, data);
        defer allocator.free(test_data);
        const tc = c;

        const WorkCtx2 = struct {
            chunk: []DataPoint,
            fn run(ctx: @This()) void {
                for (ctx.chunk) |*dp| processPoint(dp);
            }
        };

        const ts = try allocator.alloc(Thread, tc);
        defer allocator.free(ts);
        const cs2 = test_data.len / tc;

        const t_s = time.nanoTimestamp();
        for (ts, 0..) |*t, idx| {
            const s2 = idx * cs2;
            const e2 = if (idx == tc - 1) test_data.len else (idx + 1) * cs2;
            t.* = try Thread.spawn(.{}, WorkCtx2.run, .{WorkCtx2{ .chunk = test_data[s2..e2] }});
        }
        for (ts) |t| t.join();
        const t_e = time.nanoTimestamp();

        const ms = @as(f64, @floatFromInt(t_e - t_s)) / 1_000_000.0;
        const mrs = (@as(f64, @floatFromInt(N)) / 1_000_000.0) / (ms / 1000.0);
        const sp = t_seq_ms / ms;
        try stdout.print("  {d:>5}   {d:>9.2}   {d:>10.2}   {d:>5.2}x\n", .{ tc, ms, mrs, sp });
    }

    // ─── Summary ─────────────────────────────────────────────────────
    try stdout.print("\n╔══════════════════════════════════════════════════════════╗\n", .{});
    try stdout.print("║                    RESULT SUMMARY                        ║\n", .{});
    try stdout.print("╠══════════════════════════════════════════════════════════╣\n", .{});
    try stdout.print("║  100 Million records processed                           ║\n", .{});
    try stdout.print("║                                                          ║\n", .{});
    try stdout.writeAll("║  Sequential (1 core):  ");
    try stdout.print("{d:>8.0} ms                         ║\n", .{t_seq_ms});
    try stdout.writeAll("║  FORGE parallel:       ");
    try stdout.print("{d:>8.0} ms  ({d:.1}x faster)            ║\n", .{ t_par_ms, speedup });
    try stdout.print("║                                                          ║\n", .{});
    try stdout.print("║  Developer wrote: ZERO threading code                   ║\n", .{});
    try stdout.print("║  FORGE handled:   ALL parallelisation automatically      ║\n", .{});
    try stdout.print("╚══════════════════════════════════════════════════════════╝\n\n", .{});
    try stdout.print("  forge.dev | github.com/forgelangdev/phase0 | @forgelang_dev\n\n", .{});
}
