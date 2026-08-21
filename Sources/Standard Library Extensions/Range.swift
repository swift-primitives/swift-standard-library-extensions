extension Range where Bound: Strideable {

    @inlinable
    public func overlap(_ other: Range<Bound>) -> Range<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)

        guard lower < upper else { return nil }
        return lower..<upper
    }

    @inlinable
    public func clamped(to bounds: Range<Bound>) -> Range<Bound>? {
        overlap(bounds)
    }

    @inlinable
    public func split(at point: Bound) -> (lower: Range<Bound>, upper: Range<Bound>)? {
        guard contains(point), point != lowerBound else { return nil }
        return (lowerBound..<point, point..<upperBound)
    }
}
