// Result.swift
// swift-standard-library-extensions
//
// ~Copyable-aware Result type — drop-in replacement for Swift.Result

/// A result type that supports `~Copyable` success values.
///
/// Unlike `Swift.Result`, this type does not require `Success` to be `Copyable`,
/// enabling use with noncopyable types like file handles and unique resources.
///
/// When `Success` conforms to `Copyable`, this type is implicitly `Copyable`
/// and provides the full API surface of `Swift.Result`.
public enum Result<Success: ~Copyable, Failure: Swift.Error>: ~Copyable {
    case success(Success)
    case failure(Failure)
}

extension Result: Copyable where Success: Copyable {}
extension Result: Sendable where Success: Sendable, Failure: Sendable {}
extension Result: Equatable where Success: Equatable & Copyable, Failure: Equatable {}
extension Result: Hashable where Success: Hashable & Copyable, Failure: Hashable {}

// MARK: - Core API (~Copyable)

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

// MARK: - Core API (Copyable)

extension Result where Success: Copyable {
    /// Returns the success value or throws the failure error.
    @inlinable
    public func get() throws(Failure) -> Success {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

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
    public func mapError<NewFailure: Swift.Error>(
        _ transform: (Failure) -> NewFailure
    ) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value): .success(value)
        case .failure(let error): .failure(transform(error))
        }
    }

    /// Transforms the failure error into a new Result.
    @inlinable
    public func flatMapError<NewFailure: Swift.Error>(
        _ transform: (Failure) -> Result<Success, NewFailure>
    ) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value): .success(value)
        case .failure(let error): transform(error)
        }
    }

    /// The success value if the result is successful, otherwise `nil`.
    @inlinable
    public var success: Success? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    /// The failure error if the result is a failure, otherwise `nil`.
    @inlinable
    public var failure: Failure? {
        guard case .failure(let error) = self else { return nil }
        return error
    }

    /// Combines two results into a single result containing a tuple of both successes.
    @inlinable
    public func zip<OtherSuccess>(
        _ other: Result<OtherSuccess, Failure>
    ) -> Result<(Success, OtherSuccess), Failure> {
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
    @inlinable
    public func zip<OtherSuccess, Combined>(
        _ other: Result<OtherSuccess, Failure>,
        with combine: (Success, OtherSuccess) -> Combined
    ) -> Result<Combined, Failure> {
        zip(other).map { combine($0.0, $0.1) }
    }
}

extension Result where Success: Copyable {
    /// Creates a result from a typed-throws closure.
    ///
    /// Unlike stdlib's `init(catching:)` — constrained to `Failure` being the
    /// untyped `Error` existential — this initializer preserves the concrete
    /// error type through typed throws. Inside this initializer, `catch` binds
    /// `error` as `Failure` (typed), not the erased `Error` type.
    @inlinable
    public init(catching body: () throws(Failure) -> Success) {
        do throws(Failure) {
            self = .success(try body())
        } catch {
            self = .failure(error)
        }
    }
}
