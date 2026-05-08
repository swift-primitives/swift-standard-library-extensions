extension String {
    /// A result builder for declaratively constructing strings.
    ///
    /// Joins multiple string expressions with newlines.
    ///
    /// ```swift
    /// let text = String {
    ///     "Hello"
    ///     "World"
    /// }
    /// // "Hello\nWorld"
    /// ```
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression<S: StringProtocol>(_ expression: S) -> String {
            String(expression)
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression<S: StringProtocol>(_ expression: S?) -> String {
            expression.map { String($0) } ?? ""
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: String) -> String {
            first
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> String {
            ""
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> String {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(accumulated: String, next: String) -> String {
            if accumulated.isEmpty {
                next
            } else {
                accumulated + "\n" + next
            }
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> String {
            ""
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: String?) -> String {
            component ?? ""
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: String) -> String {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: String) -> String {
            second
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [String]) -> String {
            components.joined(separator: "\n")
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: String) -> String {
            component
        }
    }
}

extension String {
    /// Builds a string from a `@String.Builder` closure.
    @inlinable
    public init(@Builder _ builder: () -> String) {
        self = builder()
    }
}

extension Substring {
    /// A result builder for declaratively constructing substrings.
    ///
    /// Uses `String.Builder` internally and converts the final result to `Substring`.
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression<S: StringProtocol>(_ expression: S) -> String {
            String.Builder.buildExpression(expression)
        }

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression<S: StringProtocol>(_ expression: S?) -> String {
            String.Builder.buildExpression(expression)
        }

        // MARK: - Partial Block Building

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: String) -> String {
            String.Builder.buildPartialBlock(first: first)
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Void) -> String {
            String.Builder.buildPartialBlock(first: first)
        }

        /// Establishes the first sub-component of a partial block.
        @inlinable
        public static func buildPartialBlock(first: Never) -> String {}

        /// Folds the next sub-component into the accumulated partial block.
        @inlinable
        public static func buildPartialBlock(accumulated: String, next: String) -> String {
            String.Builder.buildPartialBlock(accumulated: accumulated, next: next)
        }

        // MARK: - Block Building

        /// Returns the empty component for an empty block.
        @inlinable
        public static func buildBlock() -> String {
            String.Builder.buildBlock()
        }

        // MARK: - Control Flow

        /// Resolves an `if`-without-`else` clause to its component or the empty value.
        @inlinable
        public static func buildOptional(_ component: String?) -> String {
            String.Builder.buildOptional(component)
        }

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: String) -> String {
            String.Builder.buildEither(first: first)
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: String) -> String {
            String.Builder.buildEither(second: second)
        }

        /// Concatenates the components produced by a `for`-loop.
        @inlinable
        public static func buildArray(_ components: [String]) -> String {
            String.Builder.buildArray(components)
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: String) -> String {
            String.Builder.buildLimitedAvailability(component)
        }

        // MARK: - Final Result

        /// Transforms the builder's component into the final result.
        @inlinable
        public static func buildFinalResult(_ component: String) -> Substring {
            Substring(component)
        }
    }
}

extension Substring {
    /// Builds a substring from a `@Substring.Builder` closure.
    @inlinable
    public init(@Builder _ builder: () -> Substring) {
        self = builder()
    }
}
