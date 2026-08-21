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
