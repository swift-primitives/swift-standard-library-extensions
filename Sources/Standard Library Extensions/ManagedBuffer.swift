// ManagedBuffer.swift
// swift-standard-library-extensions
//
// Typed throws overloads for ManagedBuffer methods.

extension ManagedBuffer {
    /// Typed throws overload for `withUnsafeMutablePointerToElements`.
    ///
    /// The stdlib version uses `rethrows` which erases typed errors.
    /// This overload preserves the error type using the Result pattern.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeMutablePointerToElements<R, E: Swift.Error>(
        _ body: (UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        let result: Result<R, E> = unsafe self.withUnsafeMutablePointerToElements { pointer in
            do throws(E) {
                return .success(try unsafe body(pointer))
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }

    /// Typed throws overload for `withUnsafeMutablePointerToHeader`.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeMutablePointerToHeader<R, E: Swift.Error>(
        _ body: (UnsafeMutablePointer<Header>) throws(E) -> R
    ) throws(E) -> R {
        let result: Result<R, E> = unsafe self.withUnsafeMutablePointerToHeader { pointer in
            do throws(E) {
                return .success(try unsafe body(pointer))
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }

    /// Typed throws overload for `withUnsafeMutablePointers`.
    @inlinable
    @_disfavoredOverload
    public func withUnsafeMutablePointers<R, E: Swift.Error>(
        _ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        let result: Result<R, E> = unsafe self.withUnsafeMutablePointers { header, elements in
            do throws(E) {
                return .success(try unsafe body(header, elements))
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }
}
