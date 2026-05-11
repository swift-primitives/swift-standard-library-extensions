extension Dictionary {
    /// Result builder for declaratively constructing dictionaries.
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: (Key, Value)) -> [Key: Value] {
            [expression.0: expression.1]
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: [Key: Value]) -> [Key: Value] {
            expression
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: [(Key, Value)]) -> [Key: Value] {
            Dictionary(expression, uniquingKeysWith: { _, new in new })
        }

        /// Bulk-add a sequence of key-value pairs without per-iteration allocation.
        @inlinable
        public static func buildExpression<S: Swift.Sequence>(_ expression: S) -> [Key: Value]
        where S.Element == (Key, Value) {
            Dictionary(expression, uniquingKeysWith: { _, new in new })
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: (Key, Value)?) -> [Key: Value] {
            expression.map { [$0.0: $0.1] } ?? [:]
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: [Key: Value]) -> [Key: Value] {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> [Key: Value] {
            [:]
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> [Key: Value] {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(
            accumulated: consuming [Key: Value],
            next: [Key: Value]
        ) -> [Key: Value] {
            accumulated.merge(next, uniquingKeysWith: { _, new in new })
            return accumulated
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> [Key: Value] {
            [:]
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: [Key: Value]?) -> [Key: Value] {
            component ?? [:]
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: [Key: Value]) -> [Key: Value] {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: [Key: Value]) -> [Key: Value] {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [[Key: Value]]) -> [Key: Value] {
            components.reduce(into: [:]) { result, dict in
                result.merge(dict, uniquingKeysWith: { _, new in new })
            }
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: [Key: Value]) -> [Key: Value] {
            component
        }
    }
}

extension Dictionary {
    /// Builds a dictionary from a `@Dictionary.Builder` closure.
    @inlinable
    public init(@Dictionary<Key, Value>.Builder _ builder: () -> [Key: Value]) {
        self = builder()
    }
}
