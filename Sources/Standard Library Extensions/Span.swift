// Span.swift
// swift-standard-library-extensions
//
// Typed-throws overloads for Span and MutableSpan closure-based access.
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
    public func withUnsafeBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        var thrown: E? = nil
        let result: R? = unsafe self.withUnsafeBufferPointer {
            (buffer: UnsafeBufferPointer<Element>) -> R? in
            do throws(E) {
                return try unsafe body(buffer)
            } catch {
                thrown = error
                return nil
            }
        }
        if let thrown { throw thrown }
        return unsafe result.unsafelyUnwrapped
    }
}

// MARK: - MutableSpan

extension Swift.MutableSpan where Element: Copyable {
    /// Typed-throws overload for `withUnsafeBufferPointer`.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        var thrown: E? = nil
        let result: R? = unsafe self.withUnsafeBufferPointer {
            (buffer: UnsafeBufferPointer<Element>) -> R? in
            do throws(E) {
                return try unsafe body(buffer)
            } catch {
                thrown = error
                return nil
            }
        }
        if let thrown { throw thrown }
        return unsafe result.unsafelyUnwrapped
    }

    /// Typed-throws overload for `withUnsafeMutableBufferPointer`.
    @inlinable
    @_disfavoredOverload
    @_lifetime(self: copy self)
    public mutating func withUnsafeMutableBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        var thrown: E? = nil
        let result: R? = unsafe self.withUnsafeMutableBufferPointer {
            (buffer: UnsafeMutableBufferPointer<Element>) -> R? in
            do throws(E) {
                return try unsafe body(buffer)
            } catch {
                thrown = error
                return nil
            }
        }
        if let thrown { throw thrown }
        return unsafe result.unsafelyUnwrapped
    }
}
