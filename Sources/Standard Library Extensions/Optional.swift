extension Optional {

    @inlinable
    public func unwrap<E: Swift.Error>(or error: E) throws(E) -> Wrapped {
        guard let value = self else { throw error }
        return value
    }

    @inlinable
    public func apply<Result>(_ transform: ((Wrapped) -> Result)?) -> Result? {
        guard let transform, let value = self else { return nil }
        return transform(value)
    }

    @inlinable
    public func zip<Other>(_ other: Other?) -> (Wrapped, Other)? {
        guard let value = self, let otherValue = other else { return nil }
        return (value, otherValue)
    }

    @inlinable
    public func map<NewWrapped, E: Swift.Error>(
        _ transform: (Wrapped) throws(E) -> NewWrapped
    ) throws(E) -> NewWrapped? {
        guard let value = self else { return nil }
        return try transform(value)
    }
}
