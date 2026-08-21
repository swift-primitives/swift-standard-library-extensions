extension Sequence where Element: AdditiveArithmetic {

    @inlinable
    public func sum() -> Element {
        reduce(.zero, +)
    }
}
