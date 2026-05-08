extension Optional {
    /// A result builder that returns the first non-nil value from a sequence of expressions.
    ///
    /// Use `Optional.first` to coalesce multiple optional values, returning the first
    /// one that is non-nil. This is similar to the `??` operator but works with multiple
    /// values in a declarative block syntax.
    ///
    /// ```swift
    /// let value = Optional.first {
    ///     cachedValue
    ///     computeExpensiveValue()
    ///     fallbackValue
    /// }
    /// ```
    ///
    /// The builder short-circuits: once a non-nil value is found, subsequent expressions
    /// are not evaluated.
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Wrapped) -> Wrapped? {
            expression
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Wrapped?) -> Wrapped? {
            expression
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Wrapped?) -> Wrapped? {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> Wrapped? {
            nil
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> Wrapped? {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(accumulated: Wrapped?, next: Wrapped?) -> Wrapped? {
            accumulated ?? next
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> Wrapped? {
            nil
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: Wrapped??) -> Wrapped? {
            component.flatMap { $0 }
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: Wrapped?) -> Wrapped? {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: Wrapped?) -> Wrapped? {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [Wrapped?]) -> Wrapped? {
            for component in components {
                if let value = component {
                    return value
                }
            }
            return nil
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: Wrapped?) -> Wrapped? {
            component
        }
    }
}

extension Optional {
    /// Builds an optional by returning the first non-nil value from the builder block.
    ///
    /// ```swift
    /// let value = Optional.first {
    ///     cachedValue
    ///     computeExpensiveValue()
    ///     fallbackValue
    /// }
    /// ```
    @inlinable
    public static func first(@Optional<Wrapped>.Builder _ builder: () -> Wrapped?) -> Wrapped? {
        builder()
    }
}
