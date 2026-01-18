// withUnsafeTemporaryAllocation.swift
// swift-standard-library-extensions
//
// Typed throws overloads for withUnsafeTemporaryAllocation

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
