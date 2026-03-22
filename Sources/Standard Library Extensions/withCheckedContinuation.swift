// withCheckedContinuation.swift
// swift-standard-library-extensions
//
// nonisolated(nonsending) overload for _Concurrency.withCheckedContinuation.
//
// The standard library's continuation function was not nonisolated(nonsending)
// until Swift 6.4 (PR #84944, 2026-02-27). Without it, resumed continuations
// are enqueued on the cooperative thread pool rather than executing inline on
// the caller's executor. This overload preserves the caller's isolation context.
//
// WHEN TO REMOVE: When minimum supported compiler is Swift 6.4+.
//
// See: https://forums.swift.org/t/pre-pitch-updating-with-checked-unsafe-continuation-to-support-typed-throws-and-perhaps-nonisolated-nonsending/84770
// See: https://github.com/swiftlang/swift/pull/84944

#if compiler(<6.4)

/// Suspends the current task, then calls the given closure with a checked continuation
/// for the current task, preserving the caller's isolation context.
///
/// Unlike the standard library version (pre-6.4), this overload is `nonisolated(nonsending)`,
/// meaning the continuation resumes on the caller's executor rather than hopping
/// to the cooperative thread pool.
@inlinable
public func withCheckedContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Never>) -> Void
) async -> T {
    await _Concurrency.withCheckedContinuation(function: function, body)
}

#endif
