// withUnsafeTemporaryAllocation.swift
// swift-standard-library-extensions
//
// Typed throws overloads for withUnsafeTemporaryAllocation

// MARK: - Void-returning overloads

/// Typed-throws overload of `Swift.withUnsafeTemporaryAllocation(of:capacity:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafeTemporaryAllocation<T, E: Swift.Error>(
    of type: T.Type,
    capacity: Int,
    _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> Void
) throws(E) {
    var thrown: E? = nil
    unsafe Swift.withUnsafeTemporaryAllocation(of: type, capacity: capacity) { buffer in
        do throws(E) {
            unsafe try body(buffer)
        } catch {
            thrown = error
        }
    }
    if let thrown { throw thrown }
}

/// Typed-throws overload of `Swift.withUnsafeTemporaryAllocation(byteCount:alignment:_:)`.
@inlinable
@_disfavoredOverload
public func withUnsafeTemporaryAllocation<E: Swift.Error>(
    byteCount: Int,
    alignment: Int,
    _ body: (UnsafeMutableRawBufferPointer) throws(E) -> Void
) throws(E) {
    var thrown: E? = nil
    unsafe Swift.withUnsafeTemporaryAllocation(byteCount: byteCount, alignment: alignment) { buffer in
        do throws(E) {
            unsafe try body(buffer)
        } catch {
            thrown = error
        }
    }
    if let thrown { throw thrown }
}

// MARK: - Result-returning overloads

/// Typed-throws overload of `Swift.withUnsafeTemporaryAllocation(byteCount:alignment:_:)`.
@inlinable
public func withUnsafeTemporaryAllocation<R, E: Swift.Error>(
    byteCount: Int,
    alignment: Int,
    _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
) throws(E) -> R {
    let result: Result<R, E> = unsafe Swift.withUnsafeTemporaryAllocation(
        byteCount: byteCount,
        alignment: alignment
    ) { buffer in
        do throws(E) {
            return .success(try unsafe body(buffer))
        } catch {
            return .failure(error)
        }
    }
    return try result.get()
}

/// Typed-throws overload of `Swift.withUnsafeTemporaryAllocation(of:capacity:_:)`.
@inlinable
public func withUnsafeTemporaryAllocation<T, R, E: Swift.Error>(
    of type: T.Type,
    capacity: Int,
    _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> R
) throws(E) -> R {
    let result: Result<R, E> = unsafe Swift.withUnsafeTemporaryAllocation(
        of: type,
        capacity: capacity
    ) { buffer in
        do throws(E) {
            return .success(try unsafe body(buffer))
        } catch {
            return .failure(error)
        }
    }
    return try result.get()
}
