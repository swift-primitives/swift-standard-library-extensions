extension Optional {

    @resultBuilder
    public enum Builder {

        @inlinable
        public static func buildExpression(_ expression: Wrapped) -> Wrapped? {
            expression
        }

        @inlinable
        public static func buildExpression(_ expression: Wrapped?) -> Wrapped? {
            expression
        }

        @inlinable
        public static func buildPartialBlock(first: Wrapped?) -> Wrapped? {
            first
        }

        @inlinable
        public static func buildPartialBlock(first: Void) -> Wrapped? {
            nil
        }

        @inlinable
        public static func buildPartialBlock(first: Never) -> Wrapped? {}

        @inlinable
        public static func buildPartialBlock(accumulated: Wrapped?, next: Wrapped?) -> Wrapped? {
            accumulated ?? next
        }

        @inlinable
        public static func buildBlock() -> Wrapped? {
            nil
        }

        @inlinable
        public static func buildOptional(_ component: Wrapped??) -> Wrapped? {
            component.flatMap { $0 }
        }

        @inlinable
        public static func buildEither(first: Wrapped?) -> Wrapped? {
            first
        }

        @inlinable
        public static func buildEither(second: Wrapped?) -> Wrapped? {
            second
        }

        @inlinable
        public static func buildArray(_ components: [Wrapped?]) -> Wrapped? {
            for component in components {
                if let value = component {
                    return value
                }
            }
            return nil
        }

        @inlinable
        public static func buildLimitedAvailability(_ component: Wrapped?) -> Wrapped? {
            component
        }
    }
}

extension Optional {

    @inlinable
    public static func first(@Optional<Wrapped>.Builder _ builder: () -> Wrapped?) -> Wrapped? {
        builder()
    }
}
