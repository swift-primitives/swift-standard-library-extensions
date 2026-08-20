// withUnsafePointer.swift
// swift-standard-library-extensions
//
// Typed throws overloads for Swift.withUnsafePointer and related functions.
// These enable 100% typed throws in code that needs to use these functions
// without falling back to `rethrows` which erases error types.

// MARK: - withUnsafePointer (immutable value)

/// Typed-throws overload of `Swift.withUnsafePointer(to:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafePointer<T, R, E: Swift.Error>(
    to value: T,
    _ body: (UnsafePointer<T>) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = Swift.withUnsafePointer(to: value) { ptr in
        do throws(E) {
            return try unsafe body(ptr)
        } catch {
            thrown = error
            return nil
        }
    }
    if let thrown { throw thrown }
    return unsafe result.unsafelyUnwrapped
}

// MARK: - withUnsafePointer (mutable value, immutable pointer)

/// Typed-throws overload of `Swift.withUnsafePointer(to:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafePointer<T, R, E: Swift.Error>(
    to value: inout T,
    _ body: (UnsafePointer<T>) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = Swift.withUnsafePointer(to: &value) { ptr in
        do throws(E) {
            return try unsafe body(ptr)
        } catch {
            thrown = error
            return nil
        }
    }
    if let thrown { throw thrown }
    return unsafe result.unsafelyUnwrapped
}

// MARK: - withUnsafeMutablePointer

/// Typed-throws overload of `Swift.withUnsafeMutablePointer(to:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafeMutablePointer<T, R, E: Swift.Error>(
    to value: inout T,
    _ body: (UnsafeMutablePointer<T>) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = Swift.withUnsafeMutablePointer(to: &value) { ptr in
        do throws(E) {
            return try unsafe body(ptr)
        } catch {
            thrown = error
            return nil
        }
    }
    if let thrown { throw thrown }
    return unsafe result.unsafelyUnwrapped
}

// MARK: - withUnsafeBytes (immutable value)

/// Typed-throws overload of `Swift.withUnsafeBytes(of:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafeBytes<T, R, E: Swift.Error>(
    of value: T,
    _ body: (UnsafeRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = Swift.withUnsafeBytes(of: value) { bytes in
        do throws(E) {
            return try unsafe body(bytes)
        } catch {
            thrown = error
            return nil
        }
    }
    if let thrown { throw thrown }
    return unsafe result.unsafelyUnwrapped
}

// MARK: - withUnsafeBytes (mutable value)

/// Typed-throws overload of `Swift.withUnsafeBytes(of:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafeBytes<T, R, E: Swift.Error>(
    of value: inout T,
    _ body: (UnsafeRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = Swift.withUnsafeBytes(of: &value) { bytes in
        do throws(E) {
            return try unsafe body(bytes)
        } catch {
            thrown = error
            return nil
        }
    }
    if let thrown { throw thrown }
    return unsafe result.unsafelyUnwrapped
}

// MARK: - withUnsafeMutableBytes

/// Typed-throws overload of `Swift.withUnsafeMutableBytes(of:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafeMutableBytes<T, R, E: Swift.Error>(
    of value: inout T,
    _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = Swift.withUnsafeMutableBytes(of: &value) { bytes in
        do throws(E) {
            return try unsafe body(bytes)
        } catch {
            thrown = error
            return nil
        }
    }
    if let thrown { throw thrown }
    return unsafe result.unsafelyUnwrapped
}
