extension CollectionOfOne {
    /// A result builder that ensures exactly one element is provided.
    ///
    /// Use `CollectionOfOne.Builder` when you need to guarantee at compile time
    /// that exactly one element is present. This is useful for APIs that require
    /// a single value but benefit from builder syntax for conditional logic.
    ///
    /// ```swift
    /// let single: CollectionOfOne<Int> = CollectionOfOne {
    ///     if useDefault {
    ///         42
    ///     } else {
    ///         computedValue
    ///     }
    /// }
    /// ```
    ///
    /// Note: The builder enforces single-element semantics. If control flow could
    /// result in zero or multiple elements, it will not compile.
    @resultBuilder
    public enum Builder {
        // MARK: - Expression Building

        /// Lifts an expression into the builder's component type.
        @inlinable
        public static func buildExpression(_ expression: Element) -> Element {
            expression
        }

        // MARK: - Block Building

        /// Returns the single component as the block's value.
        @inlinable
        public static func buildBlock(_ component: Element) -> Element {
            component
        }

        // MARK: - Control Flow

        /// Selects the `if`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(first: Element) -> Element {
            first
        }

        /// Selects the `else`-branch component of an `if`/`else` clause.
        @inlinable
        public static func buildEither(second: Element) -> Element {
            second
        }

        /// Erases availability information from a limited-availability clause.
        @inlinable
        public static func buildLimitedAvailability(_ component: Element) -> Element {
            component
        }

        // MARK: - Final Result

        /// Transforms the builder's component into the final result.
        @inlinable
        public static func buildFinalResult(_ component: Element) -> CollectionOfOne<Element> {
            CollectionOfOne(component)
        }
    }
}

extension CollectionOfOne {
    /// Builds a single-element collection from a `@CollectionOfOne.Builder` closure.
    @inlinable
    public init(@CollectionOfOne.Builder _ builder: () -> CollectionOfOne<Element>) {
        self = builder()
    }
}
