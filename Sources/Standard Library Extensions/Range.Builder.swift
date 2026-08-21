extension Range {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression(_ expression: Range<Bound>) -> [Range<Bound>] {
            [expression]
        }

        @inlinable
        public static func buildExpression(_ expression: [Range<Bound>]) -> [Range<Bound>] {
            expression
        }

        @inlinable
        public static func buildPartialBlock(first: [Range<Bound>]) -> [Range<Bound>] {
            first
        }

        @inlinable
        public static func buildPartialBlock(first: Void) -> [Range<Bound>] {
            []
        }

        @inlinable
        public static func buildPartialBlock(first: Never) -> [Range<Bound>] {}

        @inlinable
        public static func buildPartialBlock(
            accumulated: [Range<Bound>],
            next: [Range<Bound>]
        ) -> [Range<Bound>] {
            accumulated + next
        }

        @inlinable
        public static func buildBlock() -> [Range<Bound>] {
            []
        }

        @inlinable
        public static func buildOptional(_ component: [Range<Bound>]?) -> [Range<Bound>] {
            component ?? []
        }

        @inlinable
        public static func buildEither(first: [Range<Bound>]) -> [Range<Bound>] {
            first
        }

        @inlinable
        public static func buildEither(second: [Range<Bound>]) -> [Range<Bound>] {
            second
        }

        @inlinable
        public static func buildArray(_ components: [[Range<Bound>]]) -> [Range<Bound>] {
            components.flatMap { $0 }
        }

        @inlinable
        public static func buildLimitedAvailability(_ component: [Range<Bound>]) -> [Range<Bound>] {
            component
        }
    }
}

extension Range {

    @inlinable
    public static func build(
        @Range<Bound>.Builder _ builder: () -> [Range<Bound>]
    ) -> [Range<Bound>] {
        builder()
    }
}

extension ClosedRange {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression(_ expression: ClosedRange<Bound>) -> [ClosedRange<Bound>]
        {
            [expression]
        }

        @inlinable
        public static func buildExpression(
            _ expression: [ClosedRange<Bound>]
        ) -> [ClosedRange<Bound>] {
            expression
        }

        @inlinable
        public static func buildExpression(_ expression: Bound) -> [ClosedRange<Bound>] {
            [expression...expression]
        }

        @inlinable
        public static func buildPartialBlock(first: [ClosedRange<Bound>]) -> [ClosedRange<Bound>] {
            first
        }

        @inlinable
        public static func buildPartialBlock(first: Void) -> [ClosedRange<Bound>] {
            []
        }

        @inlinable
        public static func buildPartialBlock(first: Never) -> [ClosedRange<Bound>] {}

        @inlinable
        public static func buildPartialBlock(
            accumulated: [ClosedRange<Bound>],
            next: [ClosedRange<Bound>]
        ) -> [ClosedRange<Bound>] {
            accumulated + next
        }

        @inlinable
        public static func buildBlock() -> [ClosedRange<Bound>] {
            []
        }

        @inlinable
        public static func buildOptional(_ component: [ClosedRange<Bound>]?) -> [ClosedRange<Bound>]
        {
            component ?? []
        }

        @inlinable
        public static func buildEither(first: [ClosedRange<Bound>]) -> [ClosedRange<Bound>] {
            first
        }

        @inlinable
        public static func buildEither(second: [ClosedRange<Bound>]) -> [ClosedRange<Bound>] {
            second
        }

        @inlinable
        public static func buildArray(_ components: [[ClosedRange<Bound>]]) -> [ClosedRange<Bound>]
        {
            components.flatMap { $0 }
        }

        @inlinable
        public static func buildLimitedAvailability(
            _ component: [ClosedRange<Bound>]
        ) -> [ClosedRange<Bound>] {
            component
        }
    }
}

extension ClosedRange {

    @inlinable
    public static func build(
        @ClosedRange<Bound>.Builder _ builder: () -> [ClosedRange<Bound>]
    ) -> [ClosedRange<Bound>] {
        builder()
    }
}
