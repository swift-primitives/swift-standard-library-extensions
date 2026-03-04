// Result.swift
// swift-standard-library-extensions
//
// ~Copyable-aware Result type and extensions for Swift.Result

/// A result type that supports `~Copyable` success values.
///
/// Unlike `Swift.Result`, this type does not require `Success` to be `Copyable`,
/// enabling use with noncopyable types like file handles and unique resources.
///
/// When `Success` conforms to `Copyable`, this type is implicitly `Copyable`.
public enum Result<Success: ~Copyable, Failure: Error>: ~Copyable {
    case success(Success)
    case failure(Failure)
}

extension Result: Copyable where Success: Copyable {}
extension Result: Sendable where Success: Sendable, Failure: Sendable {}

// MARK: - Core API (mirrors Swift.Result)

extension Result where Success: Copyable {
    /// Returns the success value or throws the failure error.
    @inlinable
    public func get() throws(Failure) -> Success {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

extension Result where Success: ~Copyable {
    /// Returns the success value or throws the failure error, consuming self.
    @inlinable
    public consuming func get() throws(Failure) -> Success {
        switch consume self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

extension Result where Success: Copyable {
    /// Transforms the success value using the given closure.
    @inlinable
    public func map<NewSuccess>(
        _ transform: (Success) -> NewSuccess
    ) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value): .success(transform(value))
        case .failure(let error): .failure(error)
        }
    }

    /// Transforms the success value into a new Result.
    @inlinable
    public func flatMap<NewSuccess>(
        _ transform: (Success) -> Result<NewSuccess, Failure>
    ) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value): transform(value)
        case .failure(let error): .failure(error)
        }
    }

    /// Transforms the failure error using the given closure.
    @inlinable
    public func mapError<NewFailure: Error>(
        _ transform: (Failure) -> NewFailure
    ) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value): .success(value)
        case .failure(let error): .failure(transform(error))
        }
    }

    /// Transforms the failure error into a new Result.
    @inlinable
    public func flatMapError<NewFailure: Error>(
        _ transform: (Failure) -> Result<Success, NewFailure>
    ) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value): .success(value)
        case .failure(let error): transform(error)
        }
    }
}

extension Result where Success: Copyable, Failure == any Error {
    /// Creates a result from a throwing closure.
    @inlinable
    public init(catching body: () throws -> Success) {
        do {
            self = .success(try body())
        } catch {
            self = .failure(error)
        }
    }
}

// MARK: - Swift.Result Extensions

extension Swift.Result {
    /// The success value if the result is successful, otherwise `nil`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let result: Result<Int, Error> = .success(42)
    /// result.success  // 42
    ///
    /// let failed: Result<Int, Error> = .failure(MyError.failed)
    /// failed.success  // nil
    /// ```
    public var success: Success? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    /// The failure error if the result is a failure, otherwise `nil`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let failed: Result<Int, Error> = .failure(MyError.failed)
    /// failed.failure  // MyError.failed
    ///
    /// let result: Result<Int, Error> = .success(42)
    /// result.failure  // nil
    /// ```
    public var failure: Failure? {
        guard case .failure(let error) = self else { return nil }
        return error
    }

    /// Combines two results into a single result containing a tuple of both successes.
    ///
    /// Returns a success containing both values if both results are successful.
    /// If either result is a failure, returns the first failure encountered.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let r1: Result<Int, Error> = .success(1)
    /// let r2: Result<String, Error> = .success("hello")
    /// r1.zip(r2)  // .success((1, "hello"))
    ///
    /// let r3: Result<Int, Error> = .failure(MyError.failed)
    /// r1.zip(r3)  // .failure(MyError.failed)
    /// ```
    public func zip<OtherSuccess>(
        _ other: Swift.Result<OtherSuccess, Failure>
    ) -> Swift.Result<(Success, OtherSuccess), Failure> {
        switch (self, other) {
        case (.success(let a), .success(let b)):
            return .success((a, b))
        case (.failure(let error), _):
            return .failure(error)
        case (_, .failure(let error)):
            return .failure(error)
        }
    }

    /// Combines two results by applying a transformation to both success values.
    ///
    /// Returns a success containing the combined result if both results are successful.
    /// If either result is a failure, returns the first failure encountered.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let r1: Result<Int, Error> = .success(2)
    /// let r2: Result<Int, Error> = .success(3)
    /// r1.zip(r2, with: +)  // .success(5)
    /// ```
    public func zip<OtherSuccess, Combined>(
        _ other: Swift.Result<OtherSuccess, Failure>,
        with combine: (Success, OtherSuccess) -> Combined
    ) -> Swift.Result<Combined, Failure> {
        zip(other).map { combine($0.0, $0.1) }
    }
}
