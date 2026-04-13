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
// Four overloads exist, resolved by two axes:
//
//   Closure async-ness (sync vs async):
//     Sync — no await in body. Zero interleaving (compile-time guarantee).
//     Async — body contains await. On shared executor, no actual suspension.
//
//   Return copyability (Copyable vs ~Copyable):
//     Compiler selects ~Copyable overload when R doesn't conform to Copyable.
//
// See: Point-Free #362 "Isolation: Actor Enqueuing"

// MARK: - Copyable return

extension Actor {
    /// Executes a synchronous closure with exclusive access to this actor.
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

    /// Executes an asynchronous closure with access to this actor.
    ///
    /// Like the synchronous overload, suspends once to enter the actor's
    /// isolation domain. The closure may contain `await` expressions —
    /// for example, calling another actor that shares the same executor.
    ///
    /// When two actors share a `SerialExecutor`, cross-actor calls from
    /// within `run` resolve synchronously at runtime (the executor check
    /// succeeds, eliding the hop). This enables multi-actor transactions
    /// with a single enqueued job.
    ///
    /// > Important: If the awaited actor is on a *different* executor,
    /// > the closure will actually suspend, allowing other tasks to
    /// > interleave on this actor. The atomicity guarantee is a runtime
    /// > property of the executor configuration, not a compile-time one.
    ///
    /// ```swift
    /// // db and cache share one executor:
    /// await db.run { db in
    ///     db.set("key", "value")
    ///     await cache.set("key", "value")  // same executor → no suspension
    /// }
    /// ```
    ///
    /// - Parameter body: A sendable async closure receiving isolated access.
    /// - Returns: The value returned by `body`.
    @inlinable
    public func run<R, Failure: Error>(
        _ body: @Sendable (isolated Self) async throws(Failure) -> sending R
    ) async throws(Failure) -> sending R {
        try await body(self)
    }
}

// MARK: - ~Copyable return

extension Actor {
    /// Executes a synchronous closure returning a `~Copyable` value.
    ///
    /// Identical to the `Copyable` overload but accepts non-copyable return
    /// types such as file handles, unique resources, or `~Copyable` bundles.
    /// The compiler selects this overload when `R` does not conform to `Copyable`.
    @inlinable
    public func run<R: ~Copyable, Failure: Error>(
        _ body: @Sendable (isolated Self) throws(Failure) -> sending R
    ) throws(Failure) -> sending R {
        try body(self)
    }

    /// Executes an asynchronous closure returning a `~Copyable` value.
    ///
    /// Combines the async `run` semantics (cross-actor calls, shared executor
    /// transactions) with `~Copyable` return support.
    @inlinable
    public func run<R: ~Copyable, Failure: Error>(
        _ body: @Sendable (isolated Self) async throws(Failure) -> sending R
    ) async throws(Failure) -> sending R {
        try await body(self)
    }
}
