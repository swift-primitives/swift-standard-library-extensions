# Standard Library Extensions

[![CI](https://github.com/swift-primitives/swift-standard-library-extensions/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-standard-library-extensions/actions/workflows/ci.yml)
[![Swift Package Index — Swift](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswift-primitives%2Fswift-standard-library-extensions%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/swift-primitives/swift-standard-library-extensions)
[![Swift Package Index — Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fswift-primitives%2Fswift-standard-library-extensions%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/swift-primitives/swift-standard-library-extensions)

Targeted extensions to the Swift standard library: typed-throws overloads for closure-based stdlib APIs, result-builder DSLs for the standard collection types, safe-indexing accessors, and a `nonisolated(nonsending)` overload of `withTaskCancellationHandler`. Foundation-free. Embedded-compatible.

## Quick Start

Pin to a version range and import:

```swift
import Standard_Library_Extensions
```

### Typed throws across stdlib closures

The standard library's closure-based APIs (`withUnsafeBufferPointer`, `withUnsafeBytes`, `withUnsafePointer`, `withUnsafeTemporaryAllocation`, `Span.withUnsafeBufferPointer`, `Array.withUnsafeBufferPointer`, …) are declared `rethrows`, which erases the closure's typed error. This package adds parallel overloads that preserve `throws(E)`:

```swift
enum ParseError: Error { case invalid }

let bytes: [UInt8] = [0x48, 0x65, 0x6c]
let first: UInt8 = try bytes.withUnsafeBufferPointer { buffer throws(ParseError) in
    guard buffer.count > 0 else { throw .invalid }
    return buffer[0]
}
// Error type ParseError is preserved at the call site.
```

Without this package, the `throws(ParseError)` constraint is lost the moment the closure crosses a `rethrows` boundary.

### Declarative collection construction with control flow

Result-builder DSLs are provided for `Array`, `ArraySlice`, `ContiguousArray`, `Set`, `Dictionary`, `CollectionOfOne`, `Optional`, `Range`, `ClosedRange`, `Bool`, `Result`, `String`, and `Substring`:

```swift
let numbers = Array {
    1
    2
    if includeThree {
        3
    }
    for n in 4...6 {
        n
    }
}
// Builds the array declaratively without intermediate `+` concatenations.
```

### Safe indexing

```swift
let xs = [10, 20, 30]
xs[safe: 1..<2]    // Optional(ArraySlice([20]))
xs[safe: 5..<10]   // nil — out of bounds, no crash
xs[safe: -1..<2]   // nil — invalid range, no crash
```

### `nonisolated(nonsending)` cancellation handler

Standard library's `withTaskCancellationHandler` is not `nonisolated(nonsending)`, which can introduce executor hops. This package's overload preserves the caller's isolation context:

```swift
let result = try await withTaskCancellationHandler {
    try await someOperation()
} onCancel: {
    cancelExternalResource()
}
// No unnecessary suspension at the operation boundary.
```

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/swift-primitives/swift-standard-library-extensions.git",
        from: "0.1.0"
    ),
]
```

Then add the target dependency:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Standard Library Extensions", package: "swift-standard-library-extensions"),
    ]
)
```

## Architecture

The package ships two targets:

| Target | Role |
|--------|------|
| `Standard Library Extensions` | Main target — extensions and overloads. |
| `Standard Library Extensions Test Support` | Test-support shell for downstream packages that wish to import test fixtures. |

Source files follow one type per file; nested types use the Type.NestedType.swift naming pattern (e.g., `Array.Builder.swift`, `Result.Builder.swift`).

## Platform Support

The package is `nonisolated(nonsending)`-aware and uses Swift 6 language features: typed throws (`throws(E)`), `~Copyable`, `~Escapable`, `LifetimeDependence`, and `SuppressedAssociatedTypes`. Built against Swift 6.3 (stable) and Swift 6.4-dev (nightly).

| Platform | Minimum |
|----------|---------|
| macOS | 26.0 |
| iOS | 26.0 |
| tvOS | 26.0 |
| watchOS | 26.0 |
| visionOS | 26.0 |
| Linux | Swift 6.3 |
| Embedded Swift | Swift 6.4-dev |

## Stability

Pre-1.0. APIs are still evolving and may change between minor versions until 1.0.0 is tagged. Within the 0.x.y line, `0.<major>.0` releases may carry breaking changes; `0.<major>.<patch>` releases are additive only.

## Community

<!-- BEGIN: discussion -->
Discuss this package: [swift-institute/discussions/22](https://github.com/orgs/swift-institute/discussions/22)
<!-- END: discussion -->

## License

Apache License 2.0 — see [LICENSE.md](./LICENSE.md).
