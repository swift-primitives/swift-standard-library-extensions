// swift-format-ignore-file: AmbiguousTrailingClosureOverload
//
// The two `Result.first(_:)` overloads (returning `Result<Success, Failure>` and
// `Result<Success, Failure>?`) share a base name. The optional-returning overload
// is marked `@_disfavoredOverload`, which resolves the call-site ambiguity at type
// check. swift-format's syntactic check does not see that attribute and would
// otherwise flag both overloads.

extension Result where Success: Copyable {
    /// Namespace for Result builders.
    public enum Builder {
        /// A result builder that chains fallible operations, returning the first success.
        ///
        /// Use `Result.first` to try multiple operations in sequence, returning the first
        /// successful result. If all operations fail, returns the last failure.
        ///
        /// ```swift
        /// let result: Result<Data, Error> = Result.first {
        ///     try loadFromCache()
        ///     try loadFromDisk()
        ///     try loadFromNetwork()
        /// }
        /// ```
        ///
        /// The builder short-circuits: once a success is found, subsequent operations
        /// are not evaluated.
        @resultBuilder
        public enum First {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Success) -> Result<Success, Failure> {
                .success(expression)
            }

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(
                _ expression: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                expression
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(
                first: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(
                first: Result<Success, Failure>?
            ) -> Result<Success, Failure>? {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Result<Success, Failure>? {
                nil
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Result<Success, Failure> {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(
                accumulated: Result<Success, Failure>,
                next: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                switch accumulated {
                case .success:
                    accumulated

                case .failure:
                    next
                }
            }

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(
                accumulated: Result<Success, Failure>,
                next: Result<Success, Failure>?
            ) -> Result<Success, Failure> {
                switch accumulated {
                case .success:
                    accumulated

                case .failure:
                    next ?? accumulated
                }
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(
                _ component: Result<Success, Failure>?
            ) -> Result<Success, Failure>? {
                component
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(
                first: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(
                second: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(
                _ components: [Result<Success, Failure>]
            ) -> Result<Success, Failure>? {
                var lastFailure: Result<Success, Failure>?
                for component in components {
                    switch component {
                    case .success:
                        return component

                    case .failure:
                        lastFailure = component
                    }
                }
                return lastFailure
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(
                _ component: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                component
            }
        }

        /// A result builder that collects all successes into an array.
        ///
        /// Use `Result.all` to collect all successful results. If any operation fails,
        /// returns the first failure encountered.
        ///
        /// ```swift
        /// let results: Result<[User], Error> = Result.all {
        ///     try fetchUser(id: 1)
        ///     try fetchUser(id: 2)
        ///     try fetchUser(id: 3)
        /// }
        /// ```
        @resultBuilder
        public enum All {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Success) -> Result<[Success], Failure>
            {
                .success([expression])
            }

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(
                _ expression: Result<Success, Failure>
            ) -> Result<[Success], Failure> {
                expression.map { [$0] }
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(
                first: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Result<[Success], Failure> {
                .success([])
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Result<[Success], Failure> {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(
                accumulated: Result<[Success], Failure>,
                next: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                switch (accumulated, next) {
                case (.success(let accValues), .success(let nextValues)):
                    .success(accValues + nextValues)

                case (.failure(let error), _):
                    .failure(error)

                case (_, .failure(let error)):
                    .failure(error)
                }
            }

            // MARK: - Block Building

            /// Returns the empty component for an empty block.
            @inlinable
            public static func buildBlock() -> Result<[Success], Failure> {
                .success([])
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(
                _ component: Result<[Success], Failure>?
            ) -> Result<[Success], Failure> {
                component ?? .success([])
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(
                first: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(
                second: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(
                _ components: [Result<[Success], Failure>]
            ) -> Result<[Success], Failure> {
                var collected: [Success] = []
                for component in components {
                    switch component {
                    case .success(let values):
                        collected.append(contentsOf: values)

                    case .failure(let error):
                        return .failure(error)
                    }
                }
                return .success(collected)
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(
                _ component: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                component
            }
        }
    }
}

// MARK: - Convenience Entry Points

extension Result where Success: Copyable {
    /// Tries each operation in sequence; returns the first success or the final failure.
    ///
    /// The `Result<…>?` overload below carries `@_disfavoredOverload`, so the type checker
    /// resolves the trailing-closure call site unambiguously despite the shared base name.
    @inlinable
    public static func first(
        @Builder.First _ builder: () -> Result<Success, Failure>
    ) -> Result<Success, Failure> {
        builder()
    }

    /// Tries each operation in sequence; returns the first success or the final failure.
    @inlinable
    @_disfavoredOverload
    public static func first(
        @Builder.First _ builder: () -> Result<Success, Failure>?
    ) -> Result<Success, Failure>? {
        builder()
    }

    /// Runs every operation; returns all successes or fails on the first error.
    @inlinable
    public static func all(
        @Builder.All _ builder: () -> Result<[Success], Failure>
    ) -> Result<[Success], Failure> {
        builder()
    }
}
