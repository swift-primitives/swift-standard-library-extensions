// withUnsafePointer.swift
// swift-standard-library-extensions
//
// Typed throws overloads for Swift.withUnsafePointer and related functions.
// These enable 100% typed throws in code that needs to use these functions
// without falling back to `rethrows` which erases error types.

// MARK: - withUnsafePointer (immutable value)

@inlinable
@_disfavoredOverload
public func withUnsafePointer<T, R, E: Error>(
    to value: T,
    _ body: (UnsafePointer<T>) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = unsafe Swift.withUnsafePointer(to: value) { ptr in
        do {
            return try unsafe body(ptr)
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

// MARK: - withUnsafePointer (mutable value, immutable pointer)

@inlinable
@_disfavoredOverload
public func withUnsafePointer<T, R, E: Error>(
    to value: inout T,
    _ body: (UnsafePointer<T>) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = unsafe Swift.withUnsafePointer(to: &value) { ptr in
        do {
            return try unsafe body(ptr)
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

// MARK: - withUnsafeMutablePointer

@inlinable
@_disfavoredOverload
public func withUnsafeMutablePointer<T, R, E: Error>(
    to value: inout T,
    _ body: (UnsafeMutablePointer<T>) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = unsafe Swift.withUnsafeMutablePointer(to: &value) { ptr in
        do {
            return try unsafe body(ptr)
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

// MARK: - withUnsafeBytes (immutable value)

@inlinable
@_disfavoredOverload
public func withUnsafeBytes<T, R, E: Error>(
    of value: T,
    _ body: (UnsafeRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = unsafe Swift.withUnsafeBytes(of: value) { bytes in
        do {
            return try unsafe body(bytes)
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

// MARK: - withUnsafeBytes (mutable value)

@inlinable
@_disfavoredOverload
public func withUnsafeBytes<T, R, E: Error>(
    of value: inout T,
    _ body: (UnsafeRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = unsafe Swift.withUnsafeBytes(of: &value) { bytes in
        do {
            return try unsafe body(bytes)
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

// MARK: - withUnsafeMutableBytes

@inlinable
@_disfavoredOverload
public func withUnsafeMutableBytes<T, R, E: Error>(
    of value: inout T,
    _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    var thrown: E? = nil
    let result: R? = unsafe Swift.withUnsafeMutableBytes(of: &value) { bytes in
        do {
            return try unsafe body(bytes)
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
