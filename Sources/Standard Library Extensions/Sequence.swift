// Sequence.swift
// swift-standard-library-extensions
//
// Extensions for Swift standard library Sequence

// MARK: - Count

extension Sequence {
    /// Returns the number of elements that satisfy the predicate.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].count(where: { $0.isMultiple(of: 2) })  // 2
    /// ["a", "bb", "ccc"].count(where: { $0.count > 1 })       // 2
    /// ```
    @inlinable
    public func count<E: Swift.Error>(where predicate: (Element) throws(E) -> Bool) throws(E) -> Int
    {
        // WORKAROUND: Manual loop instead of `reduce(_:_:)` with typed throws
        // WHY: stdlib `reduce(_:_:)` does not support typed throws (`throws(E)`)
        // WHEN TO REMOVE: When stdlib gains typed-throws overloads of `reduce(_:_:)`
        // TRACKING: https://github.com/swiftlang/swift/issues/68734
        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }

}

extension Sequence where Element: Hashable {
    /// Returns a dictionary mapping each unique element to its frequency count.
    ///
    /// Counts how many times each element appears in the sequence.
    /// Use this to analyze element distribution or find duplicates.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 2, 3, 1, 4, 2].frequencies()  // [1: 2, 2: 3, 3: 1, 4: 1]
    /// "hello".frequencies()                // ["h": 1, "e": 1, "l": 2, "o": 1]
    /// ```
    @inlinable
    public func frequencies() -> [Element: Int] {
        reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
    }
}

extension Sequence where Element: Comparable {
    /// Returns `true` if the sequence is sorted in ascending order.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].isSorted()     // true
    /// [1, 3, 2, 4, 5].isSorted()     // false
    /// [5, 4, 3, 2, 1].isSorted()     // false
    /// ```
    @inlinable
    public func isSorted() -> Bool {
        var previous: Element?

        for element in self {
            if let prev = previous, prev > element {
                return false
            }
            previous = element
        }

        return true
    }

    /// Returns `true` if the sequence is sorted according to the given comparator.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [5, 4, 3, 2, 1].isSorted(by: >)  // true (descending)
    /// ["a", "bb", "ccc"].isSorted(by: { $0.count < $1.count })  // true
    /// ```
    @inlinable
    public func isSorted<E: Swift.Error>(
        by areInIncreasingOrder: (Element, Element) throws(E) -> Bool
    ) throws(E) -> Bool {
        var previous: Element?

        for element in self {
            if let prev = previous, try !areInIncreasingOrder(prev, element) {
                return false
            }
            previous = element
        }

        return true
    }

    /// Returns the N largest elements in descending order.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [3, 1, 4, 1, 5, 9, 2].max(count: 3)  // [9, 5, 4]
    /// [1, 2, 3].max(count: 5)              // [3, 2, 1]
    /// ```
    @inlinable
    public func max(count: Int) -> [Element] {
        guard count > 0 else { return [] }
        var result: [Element] = []

        for element in self {
            if result.count < count {
                result.append(element)
                result.sort(by: >)
            } else if let last = result.last, element > last {
                result[result.endIndex - 1] = element
                result.sort(by: >)
            }
        }

        return result
    }

    /// Returns the N smallest elements in ascending order.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [3, 1, 4, 1, 5, 9, 2].min(count: 3)  // [1, 1, 2]
    /// [1, 2, 3].min(count: 5)              // [1, 2, 3]
    /// ```
    @inlinable
    public func min(count: Int) -> [Element] {
        guard count > 0 else { return [] }
        var result: [Element] = []

        for element in self {
            if result.count < count {
                result.append(element)
                result.sort()
            } else if let last = result.last, element < last {
                result[result.endIndex - 1] = element
                result.sort()
            }
        }

        return result
    }
}
