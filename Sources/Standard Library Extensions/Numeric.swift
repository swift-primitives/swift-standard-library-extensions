extension Sequence where Element: Numeric {

    @inlinable
    public func product() -> Element {
        reduce(1, *)
    }
}

extension Sequence where Element: BinaryInteger {

    @inlinable
    public func mean() -> Element? {
        let elements = Array(self)
        guard !elements.isEmpty else { return nil }
        return elements.reduce(.zero, +) / Element(elements.count)
    }
}

extension Sequence where Element: BinaryFloatingPoint {

    @inlinable
    public func mean() -> Element? {
        var sum: Element = 0
        var count: Element = 0

        for element in self {
            sum += element
            count += 1
        }

        guard count > 0 else { return nil }
        return sum / count
    }
}
