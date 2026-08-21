extension Sequence {

    @inlinable
    public func count<E: Swift.Error>(where predicate: (Element) throws(E) -> Bool) throws(E) -> Int
    {

        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }

}

extension Sequence where Element: Hashable {

    @inlinable
    public func frequencies() -> [Element: Int] {
        reduce(into: [:]) { counts, element in
            counts[element, default: 0] += 1
        }
    }
}

extension Sequence where Element: Comparable {

    @inlinable
    public func isSorted() -> Bool {
        var previous: Element?

        for element in self {
            if let prev = previous, prev > element {
                return false
            }
            previous = element
        }

        return true
    }

    @inlinable
    public func isSorted<E: Swift.Error>(
        by areInIncreasingOrder: (Element, Element) throws(E) -> Bool
    ) throws(E) -> Bool {
        var previous: Element?

        for element in self {
            if let prev = previous, try !areInIncreasingOrder(prev, element) {
                return false
            }
            previous = element
        }

        return true
    }

    @inlinable
    public func max(count: Int) -> [Element] {
        guard count > 0 else { return [] }
        var result: [Element] = []

        for element in self {
            if result.count < count {
                result.append(element)
                result.sort(by: >)
            } else if let last = result.last, element > last {
                result[result.endIndex - 1] = element
                result.sort(by: >)
            }
        }

        return result
    }

    @inlinable
    public func min(count: Int) -> [Element] {
        guard count > 0 else { return [] }
        var result: [Element] = []

        for element in self {
            if result.count < count {
                result.append(element)
                result.sort()
            } else if let last = result.last, element < last {
                result[result.endIndex - 1] = element
                result.sort()
            }
        }

        return result
    }
}
