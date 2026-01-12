// Collection.swift
// swift-standards
//
// Pure Swift collection utilities

extension Collection {
    /// Safely accesses the element at the specified index, returning `nil` for invalid indices.
    ///
    /// Returns the element if the index is valid, or `nil` if the index is out of bounds.
    /// Use this to avoid crashes when accessing potentially invalid indices.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let array = [1, 2, 3]
    /// array[safe: 1]   // 2
    /// array[safe: 10]  // nil
    /// ```
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// Safely accesses the subsequence at the specified range, returning `nil` for invalid ranges.
    ///
    /// Returns the subsequence if the range is valid, or `nil` if the range is out of bounds or invalid.
    /// Use this to avoid crashes when accessing potentially invalid ranges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let array = [1, 2, 3, 4, 5]
    /// array[safe: 1..<3]   // [2, 3]
    /// array[safe: 3..<10]  // nil
    /// ```
    public subscript(safe range: Range<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex,
            range.upperBound <= endIndex,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    /// Splits the collection into arrays of the specified size.
    ///
    /// Returns an array of arrays, where each sub-array contains up to `size` elements. The last chunk may contain fewer elements.
    /// Use this to process large collections in manageable batches.
    ///
    /// ## Example
    ///
    /// ```swift
    /// [1, 2, 3, 4, 5].chunked(into: 2)  // [[1, 2], [3, 4], [5]]
    /// [1, 2, 3].chunked(into: 5)        // [[1, 2, 3]]
    /// ```
    public func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var chunks: [[Element]] = []
        var currentChunk: [Element] = []
        currentChunk.reserveCapacity(size)

        for element in self {
            currentChunk.append(element)
            if currentChunk.count == size {
                chunks.append(currentChunk)
                currentChunk = []
                currentChunk.reserveCapacity(size)
            }
        }

        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }

        return chunks
    }

    /// Splits the collection into two subsequences at the specified index.
    ///
    /// Returns a tuple containing the prefix (elements before the index) and suffix (elements from the index onward).
    /// Use this to divide a collection at a specific point.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let (prefix, suffix) = [1, 2, 3, 4, 5].split(at: 2)
    /// // prefix: [1, 2], suffix: [3, 4, 5]
    /// ```
    public func split(at index: Index) -> (SubSequence, SubSequence) {
        (self[startIndex..<index], self[index..<endIndex])
    }
}

// MARK: - Collection Trimming (forward-only, O(n))

extension Collection where Element: Hashable {
    /// Trims elements from both ends of the collection that are in the given set.
    ///
    /// Uses a single forward pass, tracking the last non-matching index.
    /// For BidirectionalCollection, a more efficient two-ended version is used.
    ///
    /// - Parameter elementsToTrim: Set of elements to remove from both ends
    /// - Returns: A subsequence with the specified elements trimmed from both ends
    @inlinable
    public func trimming(_ elementsToTrim: Set<Element>) -> SubSequence {
        trimming { elementsToTrim.contains($0) }
    }
}

extension Collection {
    /// Trims elements from both ends of the collection that satisfy the predicate.
    ///
    /// Uses a single forward pass, tracking the last non-matching index.
    /// O(n) - must scan entire collection since we can't iterate backwards.
    ///
    /// - Parameter predicate: A closure that returns `true` for elements to trim
    /// - Returns: A subsequence with matching elements trimmed from both ends
    @inlinable
    public func trimming(where predicate: (Element) -> Bool) -> SubSequence {
        var start = startIndex
        var end = startIndex
        var foundStart = false
        var current = startIndex

        while current < endIndex {
            if !predicate(self[current]) {
                if !foundStart {
                    start = current
                    foundStart = true
                }
                end = index(after: current)
            }
            current = index(after: current)
        }

        guard foundStart else {
            return self[startIndex..<startIndex]
        }
        return self[start..<end]
    }
}

// MARK: - BidirectionalCollection Trimming (two-ended, can short-circuit)

extension BidirectionalCollection where Element: Hashable {
    /// Trims elements from both ends of the collection that are in the given set.
    ///
    /// Optimized: iterates forward for leading, backward for trailing.
    /// Can short-circuit without scanning entire collection.
    ///
    /// - Parameter elementsToTrim: Set of elements to remove from both ends
    /// - Returns: A subsequence with the specified elements trimmed from both ends
    @inlinable
    public func trimming(_ elementsToTrim: Set<Element>) -> SubSequence {
        trimming { elementsToTrim.contains($0) }
    }
}

extension BidirectionalCollection {
    /// Trims elements from both ends of the collection that satisfy the predicate.
    ///
    /// Optimized: iterates forward for leading trim, backward for trailing trim.
    /// Can short-circuit if content is in the middle without scanning entire collection.
    ///
    /// - Parameter predicate: A closure that returns `true` for elements to trim
    /// - Returns: A subsequence with matching elements trimmed from both ends
    @inlinable
    public func trimming(where predicate: (Element) -> Bool) -> SubSequence {
        var start = startIndex
        var end = endIndex

        // Trim leading (forward)
        while start < end && predicate(self[start]) {
            start = index(after: start)
        }

        // Trim trailing (backward)
        while start < end {
            let beforeEnd = index(before: end)
            guard predicate(self[beforeEnd]) else { break }
            end = beforeEnd
        }

        return self[start..<end]
    }
}
