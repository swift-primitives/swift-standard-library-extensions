public enum Result<Success: ~Copyable, Failure: Swift.Error>: ~Copyable {
    case success(Success)
    case failure(Failure)
}

extension Result: Copyable where Success: Copyable {}
extension Result: Sendable where Success: Sendable, Failure: Sendable {}
extension Result: Equatable where Success: Equatable & Copyable, Failure: Equatable {}
extension Result: Hashable where Success: Hashable & Copyable, Failure: Hashable {}

extension Result where Success: ~Copyable {

    @inlinable
    public consuming func get() throws(Failure) -> Success {
        switch consume self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

extension Result where Success: Copyable {

    @inlinable
    public func get() throws(Failure) -> Success {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }

    @inlinable
    public func map<NewSuccess>(
        _ transform: (Success) -> NewSuccess
    ) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value): .success(transform(value))
        case .failure(let error): .failure(error)
        }
    }

    @inlinable
    public func flatMap<NewSuccess>(
        _ transform: (Success) -> Result<NewSuccess, Failure>
    ) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value): transform(value)
        case .failure(let error): .failure(error)
        }
    }

    @inlinable
    public func mapError<NewFailure: Swift.Error>(
        _ transform: (Failure) -> NewFailure
    ) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value): .success(value)
        case .failure(let error): .failure(transform(error))
        }
    }

    @inlinable
    public func flatMapError<NewFailure: Swift.Error>(
        _ transform: (Failure) -> Result<Success, NewFailure>
    ) -> Result<Success, NewFailure> {
        switch self {
        case .success(let value): .success(value)
        case .failure(let error): transform(error)
        }
    }

    @inlinable
    public var success: Success? {
        guard case .success(let value) = self else { return nil }
        return value
    }

    @inlinable
    public var failure: Failure? {
        guard case .failure(let error) = self else { return nil }
        return error
    }

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

    @inlinable
    public func zip<OtherSuccess, Combined>(
        _ other: Result<OtherSuccess, Failure>,
        with combine: (Success, OtherSuccess) -> Combined
    ) -> Result<Combined, Failure> {
        zip(other).map { combine($0.0, $0.1) }
    }
}

extension Result where Success: Copyable {

    @inlinable
    public init(catching body: () throws(Failure) -> Success) {
        do throws(Failure) {
            self = .success(try body())
        } catch {
            self = .failure(error)
        }
    }
}
