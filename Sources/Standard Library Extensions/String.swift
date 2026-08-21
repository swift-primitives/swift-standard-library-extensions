extension String {

    @inlinable
    public var lines: [String] {
        split(whereSeparator: { $0.isNewline }).map(Self.init)
    }

    @inlinable
    public var words: [String] {
        split(whereSeparator: { $0.isWhitespace }).map(Self.init)
    }
}
