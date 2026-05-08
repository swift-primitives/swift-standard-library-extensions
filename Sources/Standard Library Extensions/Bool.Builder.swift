extension Bool {
    /// Namespace for boolean result builders.
    public enum Builder {
        /// A result builder that combines boolean conditions with AND semantics.
        ///
        /// Use `Bool.all` to check that all conditions are true.
        /// Short-circuits on the first false value.
        ///
        /// ```swift
        /// let isValid = Bool.all {
        ///     user.isAuthenticated
        ///     user.hasPermission
        ///     !resource.isLocked
        /// }
        /// ```
        @resultBuilder
        public enum All {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Bool) -> Bool {
                expression
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Bool) -> Bool {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Bool {
                true
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Bool {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(accumulated: Bool, next: Bool) -> Bool {
                accumulated && next
            }

            // MARK: - Block Building

            /// Returns the empty component for an empty block.
            @inlinable
            public static func buildBlock() -> Bool {
                true
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(_ component: Bool?) -> Bool {
                component ?? true
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(first: Bool) -> Bool {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(second: Bool) -> Bool {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(_ components: [Bool]) -> Bool {
                components.allSatisfy { $0 }
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(_ component: Bool) -> Bool {
                component
            }
        }

        /// A result builder that combines boolean conditions with OR semantics.
        ///
        /// Use `Bool.any` to check that at least one condition is true.
        /// Short-circuits on the first true value.
        ///
        /// ```swift
        /// let canAccess = Bool.any {
        ///     user.isAdmin
        ///     user.isOwner
        ///     resource.isPublic
        /// }
        /// ```
        @resultBuilder
        public enum `Any` {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Bool) -> Bool {
                expression
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Bool) -> Bool {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Bool {
                false
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Bool {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(accumulated: Bool, next: Bool) -> Bool {
                accumulated || next
            }

            // MARK: - Block Building

            /// Returns the empty component for an empty block.
            @inlinable
            public static func buildBlock() -> Bool {
                false
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(_ component: Bool?) -> Bool {
                component ?? false
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(first: Bool) -> Bool {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(second: Bool) -> Bool {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(_ components: [Bool]) -> Bool {
                components.contains(true)
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(_ component: Bool) -> Bool {
                component
            }
        }

        /// A result builder that counts how many conditions are true.
        ///
        /// Use `Bool.count` to count true conditions.
        ///
        /// ```swift
        /// let trueCount = Bool.count {
        ///     condition1
        ///     condition2
        ///     condition3
        /// }
        /// ```
        @resultBuilder
        public enum Count {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Bool) -> Int {
                expression ? 1 : 0
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Int) -> Int {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Int {
                0
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Int {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(accumulated: Int, next: Int) -> Int {
                accumulated + next
            }

            // MARK: - Block Building

            /// Returns the empty component for an empty block.
            @inlinable
            public static func buildBlock() -> Int {
                0
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(_ component: Int?) -> Int {
                component ?? 0
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(first: Int) -> Int {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(second: Int) -> Int {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(_ components: [Int]) -> Int {
                components.reduce(0, +)
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(_ component: Int) -> Int {
                component
            }
        }

        /// A result builder that requires exactly one condition to be true.
        ///
        /// Use `Bool.one` for XOR-like semantics.
        ///
        /// ```swift
        /// let exactlyOne = Bool.one {
        ///     option1Selected
        ///     option2Selected
        ///     option3Selected
        /// }
        /// ```
        @resultBuilder
        public enum One {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Bool) -> Int {
                expression ? 1 : 0
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Int) -> Int {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Int {
                0
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Int {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(accumulated: Int, next: Int) -> Int {
                accumulated + next
            }

            // MARK: - Block Building

            /// Returns the empty component for an empty block.
            @inlinable
            public static func buildBlock() -> Int {
                0
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(_ component: Int?) -> Int {
                component ?? 0
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(first: Int) -> Int {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(second: Int) -> Int {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(_ components: [Int]) -> Int {
                components.reduce(0, +)
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(_ component: Int) -> Int {
                component
            }

            /// Transforms the builder's component into the final result.
            @inlinable
            public static func buildFinalResult(_ component: Int) -> Bool {
                component == 1
            }
        }

        /// A result builder that requires no conditions to be true.
        ///
        /// Use `Bool.none` to ensure all conditions are false.
        ///
        /// ```swift
        /// let noneSelected = Bool.none {
        ///     option1
        ///     option2
        ///     option3
        /// }
        /// ```
        @resultBuilder
        public enum None {
            // MARK: - Expression Building

            /// Lifts an expression into the builder's component type.
            @inlinable
            public static func buildExpression(_ expression: Bool) -> Bool {
                !expression
            }

            // MARK: - Partial Block Building

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Bool) -> Bool {
                first
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Void) -> Bool {
                true
            }

            /// Establishes the first sub-component of a partial block.
            @inlinable
            public static func buildPartialBlock(first: Never) -> Bool {}

            /// Folds the next sub-component into the accumulated partial block.
            @inlinable
            public static func buildPartialBlock(accumulated: Bool, next: Bool) -> Bool {
                accumulated && next
            }

            // MARK: - Block Building

            /// Returns the empty component for an empty block.
            @inlinable
            public static func buildBlock() -> Bool {
                true
            }

            // MARK: - Control Flow

            /// Resolves an `if`-without-`else` clause to its component or the empty value.
            @inlinable
            public static func buildOptional(_ component: Bool?) -> Bool {
                component ?? true
            }

            /// Selects the `if`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(first: Bool) -> Bool {
                first
            }

            /// Selects the `else`-branch component of an `if`/`else` clause.
            @inlinable
            public static func buildEither(second: Bool) -> Bool {
                second
            }

            /// Concatenates the components produced by a `for`-loop.
            @inlinable
            public static func buildArray(_ components: [Bool]) -> Bool {
                components.allSatisfy { $0 }
            }

            /// Erases availability information from a limited-availability clause.
            @inlinable
            public static func buildLimitedAvailability(_ component: Bool) -> Bool {
                component
            }
        }
    }
}

// MARK: - Convenience Entry Points

extension Bool {
    /// Returns true if all conditions in the builder are true (AND semantics).
    @inlinable
    public static func all(@Builder.All _ builder: () -> Bool) -> Bool {
        builder()
    }

    /// Returns true if any condition in the builder is true (OR semantics).
    @inlinable
    public static func any(@Builder.`Any` _ builder: () -> Bool) -> Bool {
        builder()
    }

    /// Returns the count of true conditions in the builder.
    @inlinable
    public static func count(@Builder.Count _ builder: () -> Int) -> Int {
        builder()
    }

    /// Returns true if exactly one condition in the builder is true (XOR semantics).
    @inlinable
    public static func one(@Builder.One _ builder: () -> Bool) -> Bool {
        builder()
    }

    /// Returns true if no conditions in the builder are true (NOR semantics).
    @inlinable
    public static func none(@Builder.None _ builder: () -> Bool) -> Bool {
        builder()
    }
}
