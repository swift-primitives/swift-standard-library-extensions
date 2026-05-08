// Array.swift
// swift-standard-library-extensions
//
// Extensions for Swift standard library Array

extension Array {
    /// Returns a new array with the element at the specified index removed.
    ///
    /// Creates a copy of the array without the element at the given index, leaving the original array unchanged.
    /// Use this when you need an immutable operation that preserves the original array.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let result = numbers.removing(at: 2)
    /// // result == [1, 2, 4, 5]
    /// // numbers == [1, 2, 3, 4, 5]
    /// ```
    @inlinable
    public func removing(at index: Int) -> [Element] {
        var result = self
        result.remove(at: index)
        return result
    }

    /// Returns a new array with the element inserted at the specified index.
    ///
    /// Creates a copy of the array with the given element inserted at the specified position, leaving the original array unchanged.
    /// Use this when you need an immutable insertion that preserves the original array.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 4, 5]
    /// let result = numbers.inserting(3, at: 2)
    /// // result == [1, 2, 3, 4, 5]
    /// // numbers == [1, 2, 4, 5]
    /// ```
    @inlinable
    public func inserting(_ element: Element, at index: Int) -> [Element] {
        var result = self
        result.insert(element, at: index)
        return result
    }

    /// Safely accesses the array slice at the specified range, returning `nil` for invalid ranges.
    ///
    /// Returns the array slice for valid ranges, or `nil` if the range is out of bounds or invalid.
    /// Use this to avoid crashes when accessing potentially invalid array ranges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// numbers[safe: 1..<3]   // [2, 3]
    /// numbers[safe: 3..<10]  // nil
    /// numbers[safe: -1..<2]  // nil
    /// ```
    @inlinable
    public subscript(safe range: Range<Int>) -> ArraySlice<Element>? {
        guard range.lowerBound >= 0,
            range.upperBound <= count,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    /// Safely accesses the array slice at the specified closed range, returning `nil` for invalid ranges.
    ///
    /// Returns the array slice for valid closed ranges (including upper bound), or `nil` if the range is out of bounds or invalid.
    /// Use this to avoid crashes when accessing potentially invalid array ranges.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// numbers[safe: 1...3]   // [2, 3, 4]
    /// numbers[safe: 3...10]  // nil
    /// numbers[safe: -1...2]  // nil
    /// ```
    @inlinable
    public subscript(safe range: ClosedRange<Int>) -> ArraySlice<Element>? {
        guard range.lowerBound >= 0,
            range.upperBound < count,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    /// Calls the given closure with a pointer to the array's contiguous storage, preserving typed errors.
    ///
    /// The standard library's `withUnsafeBufferPointer(_:)` erases error types through its
    /// `rethrows` signature. This variant preserves the exact error type using `throws(E)`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum ParseError: Swift.Error { case invalid }
    ///
    /// let bytes: [UInt8] = [0x48, 0x65, 0x6c, 0x6c, 0x6f]
    /// let result = try bytes.withUnsafeBufferPointer(body: { buffer in
    ///     guard buffer.count > 0 else { throw ParseError.invalid }
    ///     return buffer[0]
    /// })
    /// // Error type ParseError is preserved
    /// ```
    ///
    /// - Parameter body: A closure that receives an `UnsafeBufferPointer` to the array's storage.
    /// - Returns: The value returned by `body`.
    /// - Throws: The typed error from `body`.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeBufferPointer<T, E: Swift.Error>(
        body: (UnsafeBufferPointer<Element>) throws(E) -> T
    ) throws(E) -> T {
        let result: Result<T, E> = unsafe self.withUnsafeBufferPointer { buffer in
            do throws(E) {
                return .success(try unsafe body(buffer))
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }

    /// Calls the given closure with a mutable pointer to the array's contiguous storage, preserving typed errors.
    ///
    /// The standard library's `withUnsafeMutableBufferPointer(_:)` erases error types through its
    /// `rethrows` signature. This variant preserves the exact error type using `throws(E)`.
    ///
    /// - Parameter body: A closure that receives an `UnsafeMutableBufferPointer` to the array's storage.
    /// - Returns: The value returned by `body`.
    /// - Throws: The typed error from `body`.
    @inlinable
    @_disfavoredOverload
    public mutating func withUnsafeMutableBufferPointer<T, E: Swift.Error>(
        body: (inout UnsafeMutableBufferPointer<Element>) throws(E) -> T
    ) throws(E) -> T {
        var result: Result<T, E>?
        unsafe self.withUnsafeMutableBufferPointer { buffer in
            do throws(E) {
                result = .success(try unsafe body(&buffer))
            } catch {
                result = .failure(error)
            }
        }
        return try unsafe result.unsafelyUnwrapped.get()
    }
}
