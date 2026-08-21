extension Set {

    @inlinable
    public func partition(
        where predicate: (Element) -> Bool
    ) -> (satisfying: Set<Element>, failing: Set<Element>) {
        var satisfying = Set<Element>()
        var failing = Set<Element>()

        for element in self {
            if predicate(element) {
                satisfying.insert(element)
            } else {
                failing.insert(element)
            }
        }

        return (satisfying, failing)
    }

    @inlinable
    public func subsets(ofSize k: Int) -> Set<Set<Element>> {
        guard k >= 0 else { return [] }
        guard k <= count else { return [] }

        if k == 0 {
            return [[]]
        }

        if k == count {
            return [self]
        }

        var result = Set<Set<Element>>()
        let elements = Array(self)

        func combine(start: Int, current: Set<Element>) {
            if current.count == k {
                result.insert(current)
                return
            }

            for index in elements[start...].indices {
                var next = current
                next.insert(elements[index])
                combine(start: index + 1, current: next)
            }
        }

        combine(start: 0, current: [])
        return result
    }

    @inlinable
    public var cartesian: Cartesian {
        Cartesian(base: self)
    }

    public struct Cartesian {
        @usableFromInline
        internal let base: Set<Element>

        @usableFromInline
        internal init(base: Set<Element>) {
            self.base = base
        }
    }
}

extension Set.Cartesian {

    @inlinable
    public func product<Other>(_ other: Set<Other>) -> [(Element, Other)] {
        var result: [(Element, Other)] = []
        result.reserveCapacity(base.count * other.count)

        for element in base {
            for otherElement in other {
                result.append((element, otherElement))
            }
        }

        return result
    }

    @inlinable
    public func square() -> [(Element, Element)] {
        product(base)
    }
}
