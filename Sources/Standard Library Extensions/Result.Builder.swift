extension Result where Success: Copyable {

    public enum Builder {

        @resultBuilder
        public enum First {

            @inlinable
            public static func buildExpression(_ expression: Success) -> Result<Success, Failure> {
                .success(expression)
            }

            @inlinable
            public static func buildExpression(
                _ expression: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                expression
            }

            @inlinable
            public static func buildPartialBlock(
                first: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                first
            }

            @inlinable
            public static func buildPartialBlock(
                first: Result<Success, Failure>?
            ) -> Result<Success, Failure>? {
                first
            }

            @inlinable
            public static func buildPartialBlock(first: Void) -> Result<Success, Failure>? {
                nil
            }

            @inlinable
            public static func buildPartialBlock(first: Never) -> Result<Success, Failure> {}

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

            @inlinable
            public static func buildOptional(
                _ component: Result<Success, Failure>?
            ) -> Result<Success, Failure>? {
                component
            }

            @inlinable
            public static func buildEither(
                first: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                first
            }

            @inlinable
            public static func buildEither(
                second: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                second
            }

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

            @inlinable
            public static func buildLimitedAvailability(
                _ component: Result<Success, Failure>
            ) -> Result<Success, Failure> {
                component
            }
        }

        @resultBuilder
        public enum All {

            @inlinable
            public static func buildExpression(_ expression: Success) -> Result<[Success], Failure>
            {
                .success([expression])
            }

            @inlinable
            public static func buildExpression(
                _ expression: Result<Success, Failure>
            ) -> Result<[Success], Failure> {
                expression.map { [$0] }
            }

            @inlinable
            public static func buildPartialBlock(
                first: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                first
            }

            @inlinable
            public static func buildPartialBlock(first: Void) -> Result<[Success], Failure> {
                .success([])
            }

            @inlinable
            public static func buildPartialBlock(first: Never) -> Result<[Success], Failure> {}

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

            @inlinable
            public static func buildBlock() -> Result<[Success], Failure> {
                .success([])
            }

            @inlinable
            public static func buildOptional(
                _ component: Result<[Success], Failure>?
            ) -> Result<[Success], Failure> {
                component ?? .success([])
            }

            @inlinable
            public static func buildEither(
                first: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                first
            }

            @inlinable
            public static func buildEither(
                second: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                second
            }

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

            @inlinable
            public static func buildLimitedAvailability(
                _ component: Result<[Success], Failure>
            ) -> Result<[Success], Failure> {
                component
            }
        }
    }
}

extension Result where Success: Copyable {

    @inlinable
    public static func first(
        @Builder.First _ builder: () -> Result<Success, Failure>
    ) -> Result<Success, Failure> {
        builder()
    }

    @inlinable
    @_disfavoredOverload
    public static func first(
        @Builder.First _ builder: () -> Result<Success, Failure>?
    ) -> Result<Success, Failure>? {
        builder()
    }

    @inlinable
    public static func all(
        @Builder.All _ builder: () -> Result<[Success], Failure>
    ) -> Result<[Success], Failure> {
        builder()
    }
}
