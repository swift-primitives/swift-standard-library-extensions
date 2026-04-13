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
// Two overloads exist, disambiguated by the closure's async-ness:
//
//   await actor.run { actor in           // sync — no await in body
//       actor.a()
//       actor.b()
//   }
//
//   await actor.run { actor in           // async — body contains await
//       actor.a()
//       await otherActor.b()
//   }
//
// The sync variant guarantees zero interleaving (compile-time).
// The async variant permits cross-actor calls; on a shared executor
// these resolve without suspension (runtime guarantee only).
//
// See: Point-Free #362 "Isolation: Actor Enqueuing"

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
