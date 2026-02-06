// Span+TypedThrows.swift
// Typed throws overloads for Span and MutableSpan closure-based access.
//
// Note: Span.withUnsafeBytes already has typed throws in stdlib (requires BitwiseCopyable).
// We only add typed throws for withUnsafeBufferPointer which uses rethrows in stdlib.

// MARK: - Span



extension Swift.Span where Element: Copyable {
    /// Typed-throws overload for `withUnsafeBufferPointer`.
    ///
    /// The stdlib version uses `rethrows` which erases error types.
    /// This overload preserves typed throws.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeBufferPointer<R, E: Error>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        var thrown: E? = nil
        let result: R? = unsafe self.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<Element>) -> R? in
            do {
                return try unsafe body(buffer)
            } catch let e as E {
                thrown = e
                return nil
            } catch {
                preconditionFailure("unexpected error type")
            }
        }
        if let thrown { throw thrown }
        return result!
    }
}

// MARK: - MutableSpan

extension Swift.MutableSpan where Element: Copyable {
    /// Typed-throws overload for `withUnsafeBufferPointer`.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeBufferPointer<R, E: Error>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        var thrown: E? = nil
        let result: R? = unsafe self.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<Element>) -> R? in
            do {
                return try unsafe body(buffer)
            } catch let e as E {
                thrown = e
                return nil
            } catch {
                preconditionFailure("unexpected error type")
            }
        }
        if let thrown { throw thrown }
        return result!
    }

    /// Typed-throws overload for `withUnsafeMutableBufferPointer`.
    @inlinable
    @_disfavoredOverload
    @_lifetime(self: copy self)
    public mutating func withUnsafeMutableBufferPointer<R, E: Error>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        var thrown: E? = nil
        let result: R? = unsafe self.withUnsafeMutableBufferPointer { (buffer: UnsafeMutableBufferPointer<Element>) -> R? in
            do {
                return try unsafe body(buffer)
            } catch let e as E {
                thrown = e
                return nil
            } catch {
                preconditionFailure("unexpected error type")
            }
        }
        if let thrown { throw thrown }
        return result!
    }
}

