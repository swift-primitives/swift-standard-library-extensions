// Optional.swift
// swift-standard-library-extensions
//
// Extensions for Swift standard library Optional

extension Optional {
    /// Unwraps the optional value or throws the specified error.
    ///
    /// Returns the wrapped value if present, otherwise throws the provided error.
    /// Use this when you need to convert an optional into a throwing operation with a custom error.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let maybeValue: Int? = nil
    /// let value = try maybeValue.unwrap(or: MyError.notFound)
    /// // Throws MyError.notFound
    /// ```
    @inlinable
    public func unwrap<E: Swift.Error>(or error: E) throws(E) -> Wrapped {
        guard let value = self else { throw error }
        return value
    }

    /// Applies an optional transformation function to the optional value.
    ///
    /// Returns the result of applying the transformation if both the value and function are present, otherwise returns `nil`.
    /// Use this when both the transformation function and the value may be absent.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fn: ((Int) -> String)? = { String($0) }
    /// let value: Int? = 42
    /// value.apply(fn)  // "42"
    ///
    /// let noValue: Int? = nil
    /// noValue.apply(fn)  // nil
    /// ```
    @inlinable
    public func apply<Result>(_ transform: ((Wrapped) -> Result)?) -> Result? {
        guard let transform, let value = self else { return nil }
        return transform(value)
    }

    /// Combines two optional values into a tuple.
    ///
    /// Returns a tuple containing both values if both optionals are present, otherwise returns `nil`.
    /// Use this when you need to work with two optional values together.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let a: Int? = 1
    /// let b: String? = "hello"
    /// a.zip(b)  // (1, "hello")
    ///
    /// let c: Int? = nil
    /// c.zip(b)  // nil
    /// ```
    @inlinable
    public func zip<Other>(_ other: Other?) -> (Wrapped, Other)? {
        guard let value = self, let otherValue = other else { return nil }
        return (value, otherValue)
    }

    /// Transforms the wrapped value, propagating the transform's typed error.
    ///
    /// Behaves exactly like the standard library's `map`, but preserves a typed
    /// `throws(E)` instead of erasing it, so it can be called from a function
    /// that itself declares a typed throw.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum ConversionError: Swift.Error { case badDate }
    ///
    /// func parse(_ raw: String) throws(ConversionError) -> Date { ... }
    ///
    /// func convert(_ raw: String?) throws(ConversionError) -> Date? {
    ///     try raw.map { try parse($0) }   // typed error survives
    /// }
    /// ```
    ///
    /// - Workaround: This overload of stdlib `Optional.map` carries `throws(E)`.
    /// The standard library's `map` is `rethrows`, which is the untyped mechanism
    /// that erases the closure's error to `any Error`. This means `try optional.map { try f($0) }`
    /// cannot satisfy an enclosing `throws(SomeError)`.
    /// Once the standard library gains typed-throws overloads of `map`, this can be removed.
    /// See: https://github.com/swiftlang/swift/issues/68734
    @inlinable
    public func map<NewWrapped, E: Swift.Error>(
        _ transform: (Wrapped) throws(E) -> NewWrapped
    ) throws(E) -> NewWrapped? {
        guard let value = self else { return nil }
        return try transform(value)
    }
}
