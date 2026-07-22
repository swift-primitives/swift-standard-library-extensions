# ``Standard_Library_Extensions``

@Metadata {
    @DisplayName("Standard Library Extensions")
    @TitleHeading("Swift Primitives")
}

Targeted extensions to the Swift standard library: typed-throws overloads, result-builder DSLs for collection types, safe-indexing accessors, and pre-Swift-6.4-compiler isolation-preserving cancellation-handler compatibility.

## Overview

The standard library declares its closure-based APIs as `rethrows`, which erases the closure's typed error. This package re-exposes the same operations with `throws(E)` so consumers can retain typed-error guarantees end-to-end. It also adds result-builder support to the standard collection types, safe variants of indexing operations, and a `nonisolated(nonsending)` compatibility overload of `withTaskCancellationHandler` on compilers before Swift 6.4. Swift 6.4 and later compilers provide that cancellation-handler surface in the standard library.

The package is Foundation-free and Embedded-compatible.

## Topics

### Result builders

Declarative DSLs for constructing standard collection types with control flow.

### Typed-throws overloads

Closure-based APIs that preserve `throws(E)` instead of `rethrows`.

### Safe indexing

Range-bounded subscripts that return `nil` rather than trapping on out-of-bounds access.

### Concurrency

Isolation-aware overloads of standard concurrency primitives.

### Stdlib type extensions

Per-type ergonomic accessors and conversions.
