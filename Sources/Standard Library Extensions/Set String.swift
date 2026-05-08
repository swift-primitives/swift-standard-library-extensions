// Set String.swift
// swift-standard-library-extensions
//
// Set<String>-shaped reference data for the Swift language (keywords, etc.).

extension Set<String> {

    /// Set<String>-shaped namespace for Swift-language reference data.
    @inlinable
    public static var swift: `Swift` {
        .init()
    }

    /// Reference data for the Swift language as Set<String>-shaped collections.
    public struct `Swift` {
        @usableFromInline
        internal init() {}

        /// Swift keywords that need to be escaped with backticks when used as identifiers.
        public static let keywords: Set<String> = [
            "as", "break", "case", "catch", "class", "continue", "default", "defer",
            "do", "else", "enum", "extension", "fallthrough", "false", "fileprivate",
            "for", "func", "guard", "if", "import", "in", "init", "inout", "internal",
            "is", "let", "nil", "operator", "private", "protocol", "public", "repeat",
            "return", "self", "Self", "static", "struct", "subscript", "super", "switch",
            "throw", "throws", "true", "try", "typealias", "var", "where", "while",
        ]

        /// Wraps a Swift reserved identifier in backticks; passes other identifiers unchanged.
        @inlinable
        public func escape(_ identifier: String) -> String {
            Set<String>.Swift.keywords.contains(identifier) ? "`\(identifier)`" : identifier
        }
    }
}
