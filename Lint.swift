// swift-linter-tools-version: 0.1
// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-standard-library-extensions open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-standard-library-extensions project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Shape-γ unified consumer manifest. Tier-0 stdlib-boundary opt-out per
// [IMPL-010]: this package sits at the bottom of the dependency graph
// (zero primitive deps). The typed wrappers IMPL-010 directs writers
// toward (Index<T>, Ordinal, Cardinal, Count<T>, Offset<T>) all live at
// higher tiers — this package categorically cannot import them. Int IS
// the right type at this boundary; it's the stdlib edge that other
// primitives wrap.
//
// Scoped per-rule exclusion at the leaf level rather than a tier-side
// signal in the rule itself — keeps the rule pure (no dependency-graph
// awareness) and pushes the architectural exception to the leaf that
// owns the constraint. Migrated from the retired Lint/ nested-package
// shape (Lint/Sources/Lint/main.swift) — see [LINT-SETUP-001]. Per
// Swift 6.3+ MemberImportVisibility (SE-0444), the rule's declaring
// module is directly imported below.

import Linter
import Linter_Primitives_Rules
import Institute_Linter_Rule_Naming

Lint.run(dependencies: [
    .package(
        url: "https://github.com/swift-primitives/swift-primitives-linter-rules.git",
        branch: "main",
        products: ["Linter Primitives Rules"]
    ),
    .package(
        url: "https://github.com/swift-foundations/swift-institute-linter-rules.git",
        branch: "main",
        products: ["Institute Linter Rule Naming"]
    ),
]) {
    Lint.Rule.Bundle.primitives.excluding(rules: [
        Lint.Rule.`int public parameter`.id,
    ])
}
