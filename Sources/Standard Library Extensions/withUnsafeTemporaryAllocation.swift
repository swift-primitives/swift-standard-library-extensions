// withUnsafeTemporaryAllocation.swift
// swift-standard-library-extensions
//
// Typed throws overloads for withUnsafeTemporaryAllocation

// MARK: - Void-returning overloads

@inlinable
@_disfavoredOverload
public func withUnsafeTemporaryAllocation<T, E: Error>(
    of type: T.Type,
    capacity: Int,
    _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> Void
) throws(E) {
    var thrown: E? = nil
    unsafe Swift.withUnsafeTemporaryAllocation(of: type, capacity: capacity) { buffer in
        do {
            unsafe try body(buffer)
        } catch let e as E { thrown = e } catch { preconditionFailure("unexpected error type") }
    }
    if let thrown { throw thrown }
}

@inlinable
@_disfavoredOverload
public func withUnsafeTemporaryAllocation<E: Error>(
    byteCount: Int,
    alignment: Int,
    _ body: (UnsafeMutableRawBufferPointer) throws(E) -> Void
) throws(E) {
    var thrown: E? = nil
    unsafe Swift.withUnsafeTemporaryAllocation(byteCount: byteCount, alignment: alignment) { buffer in
        do {
            unsafe try body(buffer)
        } catch let e as E {
            thrown = e
        } catch { preconditionFailure("unexpected error type") }
    }
    if let thrown { throw thrown }
}

// MARK: - Result-returning overloads

@inlinable
public func withUnsafeTemporaryAllocation<R, E: Error>(
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

@inlinable
public func withUnsafeTemporaryAllocation<T, R, E: Error>(
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
