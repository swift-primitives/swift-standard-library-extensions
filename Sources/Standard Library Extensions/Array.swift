extension Array {

    @inlinable
    public func removing(at index: Int) -> [Element] {
        var result = self
        result.remove(at: index)
        return result
    }

    @inlinable
    public func inserting(_ element: Element, at index: Int) -> [Element] {
        var result = self
        result.insert(element, at: index)
        return result
    }

    @inlinable
    public subscript(safe range: Range<Int>) -> ArraySlice<Element>? {
        guard range.lowerBound >= 0,
            range.upperBound <= count,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    @inlinable
    public subscript(safe range: ClosedRange<Int>) -> ArraySlice<Element>? {
        guard range.lowerBound >= 0,
            range.upperBound < count,
            range.lowerBound <= range.upperBound
        else { return nil }
        return self[range]
    }

    @inlinable
    @_disfavoredOverload
    public func withUnsafeBufferPointer<T, E: Swift.Error>(
        body: (UnsafeBufferPointer<Element>) throws(E) -> T
    ) throws(E) -> T {
        let result: Result<T, E> = self.withUnsafeBufferPointer { buffer in
            do throws(E) {
                return .success(try unsafe body(buffer))
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }

    @inlinable
    @_disfavoredOverload
    public mutating func withUnsafeMutableBufferPointer<T, E: Swift.Error>(
        body: (inout UnsafeMutableBufferPointer<Element>) throws(E) -> T
    ) throws(E) -> T {
        var result: Result<T, E>?
        self.withUnsafeMutableBufferPointer { buffer in
            do throws(E) {
                result = .success(try unsafe body(&buffer))
            } catch {
                result = .failure(error)
            }
        }
        return try unsafe result.unsafelyUnwrapped.get()
    }
}
