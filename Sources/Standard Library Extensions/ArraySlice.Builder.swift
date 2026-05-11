extension ArraySlice {
    /// A result builder for declaratively constructing array slices.
    @resultBuilder
    public enum Builder {
        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Element) -> [Element] {
            [expression]
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: [Element]) -> [Element] {
            expression
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: ArraySlice<Element>) -> [Element] {
            Array(expression)
        }

        /// Bulk-add a sequence (Range, Set, lazy chain, etc.) without per-iteration allocation.
        ///
        /// Single optimized `ArraySlice.init(_ sequence:)` call.
        @inlinable
        public static func buildExpression<S: Swift.Sequence>(_ expression: S) -> [Element]
        where S.Element == Element {
            Array(expression)
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Element?) -> [Element] {
            expression.map { [$0] } ?? []
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: [Element]) -> [Element] {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> [Element] {
            []
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> [Element] {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(
            accumulated: consuming [Element],
            next: [Element]
        ) -> [Element] {
            accumulated.append(contentsOf: next)
            return accumulated
        }

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> [Element] {
            []
        }

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: [Element]?) -> [Element] {
            component ?? []
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: [Element]) -> [Element] {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: [Element]) -> [Element] {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [[Element]]) -> [Element] {
            components.flatMap { $0 }
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: [Element]) -> [Element] {
            component
        }

        /// Transforms the builder's component into the final result.
        @inlinable
        public static func buildFinalResult(_ component: [Element]) -> ArraySlice<Element> {
            ArraySlice(component)
        }
    }
}

extension ArraySlice {
    /// Builds an array slice from a `@ArraySlice.Builder` closure.
    @inlinable
    public init(@ArraySlice.Builder _ builder: () -> ArraySlice<Element>) {
        self = builder()
    }
}
