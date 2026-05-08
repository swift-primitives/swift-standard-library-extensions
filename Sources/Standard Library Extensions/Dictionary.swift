// Dictionary.swift
// swift-standard-library-extensions
//
// Extensions for Swift standard library Dictionary

extension Dictionary {
    /// Returns a new dictionary by transforming the keys while preserving values.
    ///
    /// Applies the transformation to each key. If multiple keys transform to the same value, only the last one is preserved.
    /// Use this to change key types or normalize keys.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dict = [1: "one", 2: "two"]
    /// dict.mapKeys { "key\($0)" }  // ["key1": "one", "key2": "two"]
    /// ```
    @inlinable
    public func mapKeys<E: Swift.Error, NewKey: Hashable>(
        _ transform: (Key) throws(E) -> NewKey
    ) throws(E) -> [NewKey: Value] {
        // WORKAROUND: Manual loop instead of `reduce(into:)` with typed throws
        // WHY: stdlib `reduce(into:)` does not support typed throws (`throws(E)`)
        // WHEN TO REMOVE: When stdlib gains typed-throws overloads of `reduce(into:)`
        // TRACKING: https://github.com/swiftlang/swift/issues/68734
        var result: [NewKey: Value] = [:]
        for (key, value) in self {
            result[try transform(key)] = value
        }
        return result
    }

    /// Returns a new dictionary by transforming keys and filtering out `nil` results.
    ///
    /// Applies the transformation to each key, keeping only the entries where the transformation returns a non-`nil` value.
    /// Use this to selectively transform and filter dictionary keys.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dict = [1: "one", 2: "two", 3: "three"]
    /// dict.compactMapKeys { $0 > 1 ? $0 : nil }  // [2: "two", 3: "three"]
    /// ```
    @inlinable
    public func compactMapKeys<E: Swift.Error, NewKey: Hashable>(
        _ transform: (Key) throws(E) -> NewKey?
    ) throws(E) -> [NewKey: Value] {
        // WORKAROUND: Manual loop instead of `reduce(into:)` with typed throws
        // WHY: stdlib `reduce(into:)` does not support typed throws (`throws(E)`)
        // WHEN TO REMOVE: When stdlib gains typed-throws overloads of `reduce(into:)`
        // TRACKING: https://github.com/swiftlang/swift/issues/68734
        var result: [NewKey: Value] = [:]
        for (key, value) in self {
            if let newKey = try transform(key) {
                result[newKey] = value
            }
        }
        return result
    }

    /// Compacts dictionary values, removing nil entries
    ///
    /// Natural transformation from Dict(K, Maybe(V)) to Dict(K, V).
    /// Flattens optional values, filtering out None cases.
    ///
    /// Category theory: Natural transformation ν: Dict ∘ Maybe → Dict
    /// ν: Dict(K, Maybe(V)) → Dict(K, V)
    ///
    /// Example:
    /// ```swift
    /// let dict: [String: Int?] = ["a": 1, "b": nil, "c": 3]
    /// dict.compactMapValues { $0 }  // Already exists in stdlib
    /// ```
    /// Note: compactMapValues already exists in Swift stdlib,
    /// but documented here for completeness
}

extension Dictionary where Value: Equatable {
    /// Returns a new dictionary with keys and values swapped.
    ///
    /// If multiple keys have the same value, only the last key-value pair is preserved in the result.
    /// Use this to create a reverse lookup dictionary.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let dict = ["a": 1, "b": 2]
    /// dict.inverted()  // [1: "a", 2: "b"]
    /// ```
    @inlinable
    public func inverted() -> [Value: Key] where Value: Hashable {
        reduce(into: [:]) { result, pair in
            result[pair.value] = pair.key
        }
    }
}
