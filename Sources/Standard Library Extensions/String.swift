// String.swift
// swift-standard-library-extensions
//
// Pure Swift string manipulation utilities

// String trimming has been moved to swift-incits-4-1986

// ASCII validation methods have been moved to swift-incits-4-1986

// Case transformation (String.Case, formatted(as:)) and case-insensitive hashing
// (String.Case.Insensitive, String.caseInsensitive) have been moved to
// swift-format-primitives as Format.Case, Format.Case.Insensitive,
// StringProtocol.formatted(_:), and String.caseInsensitive. See
// swift-format-primitives/Research/case-formatting-placement.md.

// StringProtocol extensions have been moved to StringProtocol.swift

extension String {
    /// The string split into separate lines.
    ///
    /// ## Example
    ///
    /// ```swift
    /// "hello\nworld\ntest".lines  // ["hello", "world", "test"]
    /// "single line".lines         // ["single line"]
    /// ```
    @inlinable
    public var lines: [String] {
        split(whereSeparator: { $0.isNewline }).map(String.init)
    }

    /// The string split into separate words.
    ///
    /// ## Example
    ///
    /// ```swift
    /// "hello world test".words  // ["hello", "world", "test"]
    /// "single".words            // ["single"]
    /// ```
    @inlinable
    public var words: [String] {
        split(whereSeparator: { $0.isWhitespace }).map(String.init)
    }
}
