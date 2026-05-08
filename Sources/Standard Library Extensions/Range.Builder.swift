extension Range {
    /// A result builder for declaratively constructing arrays of half-open ranges.
    ///
    /// Use `Range.build` to build collections of potentially discontinuous ranges.
    ///
    /// ```swift
    /// let ranges = Range.build {
    ///     0..<5
    ///     10..<15
    ///     if includeExtra {
    ///         20..<25
    ///     }
    /// }
    /// ```
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Range<Bound>) -> [Range<Bound>] {
            [expression]
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: [Range<Bound>]) -> [Range<Bound>] {
            expression
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: [Range<Bound>]) -> [Range<Bound>] {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> [Range<Bound>] {
            []
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> [Range<Bound>] {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(
            accumulated: [Range<Bound>],
            next: [Range<Bound>]
        ) -> [Range<Bound>] {
            accumulated + next
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> [Range<Bound>] {
            []
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: [Range<Bound>]?) -> [Range<Bound>] {
            component ?? []
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: [Range<Bound>]) -> [Range<Bound>] {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: [Range<Bound>]) -> [Range<Bound>] {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [[Range<Bound>]]) -> [Range<Bound>] {
            components.flatMap { $0 }
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: [Range<Bound>]) -> [Range<Bound>] {
            component
        }
    }
}

extension Range {
    /// Builds an array of half-open ranges from a `@Range.Builder` closure.
    @inlinable
    public static func build(
        @Range<Bound>.Builder _ builder: () -> [Range<Bound>]
    ) -> [Range<Bound>] {
        builder()
    }
}

// MARK: - ClosedRange Builder (delegates to Range.Builder pattern)

extension ClosedRange {
    /// A result builder for declaratively constructing arrays of closed ranges.
    ///
    /// Use `ClosedRange.build` to build collections of potentially discontinuous ranges.
    ///
    /// ```swift
    /// let ranges = ClosedRange.build {
    ///     1...5
    ///     10...15
    ///     if includeExtra {
    ///         20...25
    ///     }
    /// }
    /// ```
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: ClosedRange<Bound>) -> [ClosedRange<Bound>] {
            [expression]
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(
            _ expression: [ClosedRange<Bound>]
        ) -> [ClosedRange<Bound>] {
            expression
        }

        /// Allows single values to be expressed as single-element closed ranges.
        @inlinable
        public static func buildExpression(_ expression: Bound) -> [ClosedRange<Bound>] {
            [expression...expression]
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: [ClosedRange<Bound>]) -> [ClosedRange<Bound>] {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> [ClosedRange<Bound>] {
            []
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> [ClosedRange<Bound>] {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(
            accumulated: [ClosedRange<Bound>],
            next: [ClosedRange<Bound>]
        ) -> [ClosedRange<Bound>] {
            accumulated + next
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> [ClosedRange<Bound>] {
            []
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: [ClosedRange<Bound>]?) -> [ClosedRange<Bound>] {
            component ?? []
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: [ClosedRange<Bound>]) -> [ClosedRange<Bound>] {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: [ClosedRange<Bound>]) -> [ClosedRange<Bound>] {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [[ClosedRange<Bound>]]) -> [ClosedRange<Bound>] {
            components.flatMap { $0 }
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(
            _ component: [ClosedRange<Bound>]
        ) -> [ClosedRange<Bound>] {
            component
        }
    }
}

extension ClosedRange {
    /// Builds an array of closed ranges from a `@ClosedRange.Builder` closure.
    @inlinable
    public static func build(
        @ClosedRange<Bound>.Builder _ builder: () -> [ClosedRange<Bound>]
    ) -> [ClosedRange<Bound>] {
        builder()
    }
}
