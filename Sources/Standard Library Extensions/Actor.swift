// Actor.swift
// swift-standard-library-extensions
//
// Transactional actor access: suspend once, run synchronously.
//
// The standard library provides MainActor.run but no equivalent for
// arbitrary actor instances. This extension fills that gap, collapsing
// multiple suspension points into a single hop for atomic multi-step
// operations.
//
// See: Point-Free #362 "Isolation: Actor Enqueuing"

extension Actor {
    /// Executes a closure with exclusive, synchronous access to this actor.
    ///
    /// Suspends the caller once to enter this actor's isolation domain,
    /// then runs `body` synchronously. No other work can interleave on
    /// this actor for the duration of the closure.
    ///
    /// The return value is transferred via `sending`, allowing both
    /// `Sendable` and freshly-created non-`Sendable` values to cross
    /// the isolation boundary.
    ///
    /// ```swift
    /// try await bank.run { bank in
    ///     let id1 = bank.openAccount(initialDeposit: 100)
    ///     let id2 = bank.openAccount(initialDeposit: 100)
    ///     bank.transfer(amount: 50, from: id1, to: id2)
    ///     // Atomic — no other task can interleave.
    /// }
    /// ```
    ///
    /// - Parameter body: A sendable closure receiving isolated access to this actor.
    /// - Returns: The value returned by `body`.
    @inlinable
    public func run<R, Failure: Error>(
        _ body: @Sendable (isolated Self) throws(Failure) -> sending R
    ) throws(Failure) -> sending R {
        try body(self)
    }
}
