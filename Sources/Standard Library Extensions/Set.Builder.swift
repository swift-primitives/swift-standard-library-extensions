extension Set {
    /// Result builder for declaratively constructing sets.
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Element) -> Set<Element> {
            [expression]
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Set<Element>) -> Set<Element> {
            expression
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: [Element]) -> Set<Element> {
            Set(expression)
        }

        /// Bulk-add a sequence (Range, Array, lazy chain, etc.) without per-iteration allocation.
        ///
        /// Single Set construction.
        @inlinable
        public static func buildExpression<S: Sequence>(_ expression: S) -> Set<Element>
        where S.Element == Element {
            Set(expression)
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Element?) -> Set<Element> {
            expression.map { [$0] } ?? []
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Set<Element>) -> Set<Element> {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> Set<Element> {
            []
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> Set<Element> {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(
            accumulated: consuming Set<Element>,
            next: Set<Element>
        ) -> Set<Element> {
            accumulated.formUnion(next)
            return accumulated
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> Set<Element> {
            []
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: Set<Element>?) -> Set<Element> {
            component ?? []
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: Set<Element>) -> Set<Element> {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: Set<Element>) -> Set<Element> {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [Set<Element>]) -> Set<Element> {
            components.reduce(into: []) { result, set in
                result.formUnion(set)
            }
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: Set<Element>) -> Set<Element> {
            component
        }
    }
}

extension Set {
    /// Builds a set from a `@Set.Builder` closure.
    @inlinable
    public init(@Set.Builder _ builder: () -> Set<Element>) {
        self = builder()
    }
}
