// withCheckedContinuation.swift
// swift-standard-library-extensions
//
// nonisolated(nonsending) overload for _Concurrency.withCheckedContinuation.
//
// The standard library's continuation function is not yet nonisolated(nonsending),
// which causes resumed continuations to be enqueued on the cooperative thread pool
// rather than executing inline on the caller's executor. This overload preserves
// the caller's isolation context so that resume() executes synchronously.
//
// Note: The throwing variant (withCheckedThrowingContinuation) is NOT provided here
// because the stdlib forces CheckedContinuation<T, any Error>, which violates
// typed-throws conventions [API-ERR-001]. Once the stdlib pre-pitch lands with
// typed-throws support for continuations, a throwing overload can be added.
//
// See: https://forums.swift.org/t/pre-pitch-updating-with-checked-unsafe-continuation-to-support-typed-throws-and-perhaps-nonisolated-nonsending/84770

/// Suspends the current task, then calls the given closure with a checked continuation
/// for the current task, preserving the caller's isolation context.
///
/// Unlike the standard library version, this overload is `nonisolated(nonsending)`,
/// meaning the continuation resumes on the caller's executor rather than hopping
/// to the cooperative thread pool.
@inlinable
public func withCheckedContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Never>) -> Void
) async -> T {
    await _Concurrency.withCheckedContinuation(function: function, body)
}
