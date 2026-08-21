extension Dictionary {

    @inlinable
    public func mapKeys<E: Swift.Error, NewKey: Hashable>(
        _ transform: (Key) throws(E) -> NewKey
    ) throws(E) -> [NewKey: Value] {

        var result: [NewKey: Value] = [:]
        for (key, value) in self {
            result[try transform(key)] = value
        }
        return result
    }

    @inlinable
    public func compactMapKeys<E: Swift.Error, NewKey: Hashable>(
        _ transform: (Key) throws(E) -> NewKey?
    ) throws(E) -> [NewKey: Value] {

        var result: [NewKey: Value] = [:]
        for (key, value) in self {
            if let newKey = try transform(key) {
                result[newKey] = value
            }
        }
        return result
    }

}

extension Dictionary where Value: Equatable {

    @inlinable
    public func inverted() -> [Value: Key] where Value: Hashable {
        reduce(into: [:]) { result, pair in
            result[pair.value] = pair.key
        }
    }
}
