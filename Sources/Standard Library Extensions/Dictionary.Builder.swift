extension Dictionary {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression(_ expression: (Key, Value)) -> [Key: Value] {
            [expression.0: expression.1]
        }

        @inlinable
        public static func buildExpression(_ expression: [Key: Value]) -> [Key: Value] {
            expression
        }

        @inlinable
        public static func buildExpression(_ expression: [(Key, Value)]) -> [Key: Value] {
            Dictionary(expression, uniquingKeysWith: { _, new in new })
        }

        @inlinable
        public static func buildExpression<S: Swift.Sequence>(_ expression: S) -> [Key: Value]
        where S.Element == (Key, Value) {
            Dictionary(expression, uniquingKeysWith: { _, new in new })
        }

        @inlinable
        public static func buildExpression(_ expression: (Key, Value)?) -> [Key: Value] {
            expression.map { [$0.0: $0.1] } ?? [:]
        }

        @inlinable
        public static func buildPartialBlock(first: [Key: Value]) -> [Key: Value] {
            first
        }

        @inlinable
        public static func buildPartialBlock(first: Void) -> [Key: Value] {
            [:]
        }

        @inlinable
        public static func buildPartialBlock(first: Never) -> [Key: Value] {}

        @inlinable
        public static func buildPartialBlock(
            accumulated: consuming [Key: Value],
            next: [Key: Value]
        ) -> [Key: Value] {
            accumulated.merge(next, uniquingKeysWith: { _, new in new })
            return accumulated
        }

        @inlinable
        public static func buildBlock() -> [Key: Value] {
            [:]
        }

        @inlinable
        public static func buildOptional(_ component: [Key: Value]?) -> [Key: Value] {
            component ?? [:]
        }

        @inlinable
        public static func buildEither(first: [Key: Value]) -> [Key: Value] {
            first
        }

        @inlinable
        public static func buildEither(second: [Key: Value]) -> [Key: Value] {
            second
        }

        @inlinable
        public static func buildArray(_ components: [[Key: Value]]) -> [Key: Value] {
            components.reduce(into: [:]) { result, dict in
                result.merge(dict, uniquingKeysWith: { _, new in new })
            }
        }

        @inlinable
        public static func buildLimitedAvailability(_ component: [Key: Value]) -> [Key: Value] {
            component
        }
    }
}

extension Dictionary {

    @inlinable
    public init(@Dictionary<Key, Value>.Builder _ builder: () -> [Key: Value]) {
        self = builder()
    }
}
