// withTaskCancellationHandler.swift
// swift-standard-library-extensions
//
// nonisolated(nonsending) overload for _Concurrency.withTaskCancellationHandler.
//
// The standard library's withTaskCancellationHandler is not yet nonisolated(nonsending),
// which can introduce unnecessary suspension points. This overload preserves
// the caller's isolation context.
//
// See: https://forums.swift.org/t/pre-pitch-updating-with-checked-unsafe-continuation-to-support-typed-throws-and-perhaps-nonisolated-nonsending/84770

/// Executes an async operation with a cancellation handler, preserving the caller's
/// isolation context.
///
/// Unlike the standard library version, this overload is `nonisolated(nonsending)`,
/// meaning neither the operation nor the cancellation check introduces an
/// unnecessary executor hop. Uses typed throws rather than `rethrows`.
@inlinable
nonisolated(nonsending)
public func withTaskCancellationHandler<T, E: Error>(
    operation: nonisolated(nonsending) () async throws(E) -> T,
    onCancel handler: @Sendable () -> Void
) async throws(E) -> T {
    do {
        return try await _Concurrency.withTaskCancellationHandler(operation: operation, onCancel: handler)
    } catch {
        // Safe: rethrows guarantees the error originates from `operation`, which throws(E).
        throw error as! E
    }
}
