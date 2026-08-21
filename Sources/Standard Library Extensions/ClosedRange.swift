extension ClosedRange where Bound: Strideable {

    @inlinable
    public func overlap(_ other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        guard lower <= upper else { return nil }
        return lower...upper
    }

    @inlinable
    public func clamped(to bounds: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        overlap(bounds)
    }
}
