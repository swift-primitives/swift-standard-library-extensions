// TaskLocal.swift
// swift-standards
//
// Extensions for Swift standard library TaskLocal

extension TaskLocal {
    /// Binds the task-local to a value for the duration of the operation, preserving typed errors.
    ///
    /// The standard library's `withValue(_:operation:)` erases error types through its
    /// `throws` signature. This variant preserves the exact error type using `throws(E)`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum MyError: Error { case failed }
    ///
    /// @TaskLocal static var context: Context?
    ///
    /// // Error type is preserved
    /// try $context.withValue(.init(), body: {
    ///     throw MyError.failed
    /// })
    /// // Throws MyError, not any Error
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to bind for the duration of the operation.
    ///   - body: The operation to execute with the bound value.
    /// - Returns: The result of the operation.
    /// - Throws: The typed error from the operation.
    @inlinable
    @_disfavoredOverload
    public func withValue<T, E: Error>(
        _ value: Value,
        body: () throws(E) -> T
    ) throws(E) -> T where Value: Sendable {
        let result: Result<T, E> = self.withValue(value) {
            do throws(E) {
                return .success(try body())
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }

    /// Binds the task-local to a value for the duration of the async operation, preserving typed errors.
    ///
    /// The standard library's `withValue(_:operation:)` erases error types through its
    /// `throws` signature. This variant preserves the exact error type using `throws(E)`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// enum MyError: Error { case failed }
    ///
    /// @TaskLocal static var context: Context?
    ///
    /// // Error type is preserved across async boundaries
    /// try await $context.withValue(.init(), body: {
    ///     await Task.yield()
    ///     throw MyError.failed
    /// })
    /// // Throws MyError, not any Error
    /// ```
    ///
    /// - Parameters:
    ///   - value: The value to bind for the duration of the operation.
    ///   - body: The async operation to execute with the bound value.
    /// - Returns: The result of the operation.
    /// - Throws: The typed error from the operation.
    @inlinable
    @_disfavoredOverload
    public func withValue<T, E: Error>(
        _ value: Value,
        body: () async throws(E) -> T
    ) async throws(E) -> T where Value: Sendable {
        let result: Result<T, E> = await self.withValue(value) {
            do throws(E) {
                return .success(try await body())
            } catch {
                return .failure(error)
            }
        }
        return try result.get()
    }
}
