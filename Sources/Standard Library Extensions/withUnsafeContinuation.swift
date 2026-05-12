// withUnsafeContinuation.swift
// swift-standard-library-extensions
//
// nonisolated(nonsending) overload for _Concurrency.withUnsafeContinuation.
//
// The standard library's continuation function is not yet nonisolated(nonsending),
// which causes resumed continuations to be enqueued on the cooperative thread pool
// rather than executing inline on the caller's executor. This overload preserves
// the caller's isolation context so that resume() executes synchronously.
//
// Note: The throwing variant (withUnsafeThrowingContinuation) is NOT provided here
// because the stdlib forces the failure parameter to the erased `Error` existential
// in the continuation type, which violates typed-throws conventions [API-ERR-001].
// Once the stdlib pre-pitch lands with typed-throws support for continuations, a
// throwing overload can be added.
//
// See: https://forums.swift.org/t/pre-pitch-updating-with-checked-unsafe-continuation-to-support-typed-throws-and-perhaps-nonisolated-nonsending/84770

#if !hasFeature(Embedded)

    /// Suspends the current task, then calls the given closure with an unsafe continuation
    /// for the current task, preserving the caller's isolation context.
    ///
    /// Unlike the standard library version, this overload is `nonisolated(nonsending)`,
    /// meaning the continuation resumes on the caller's executor rather than hopping
    /// to the cooperative thread pool.
    @inlinable
    public func withUnsafeContinuation<T>(
        _ fn: (UnsafeContinuation<T, Never>) -> Void
    ) async -> T {
        await unsafe _Concurrency.withUnsafeContinuation(fn)
    }

#endif
