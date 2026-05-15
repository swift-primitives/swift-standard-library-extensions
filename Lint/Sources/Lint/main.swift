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

internal import Linter
internal import Linter_Primitives_Rules
// `Institute_Linter_Rule_Naming` must be directly imported so the
// static-member lookup on `.`int public parameter`` (declared in
// that module) is visible per Swift 6 MemberImportVisibility.
// Transitive visibility through Linter_Primitives_Rules is
// insufficient — the rule's declaring module must be in the file's
// import set.
internal import Institute_Linter_Rule_Naming

// Tier-0 stdlib-boundary opt-out per [IMPL-010]: this package sits at
// the bottom of the dependency graph (zero primitive deps). The typed
// wrappers IMPL-010 directs writers toward (Index<T>, Ordinal, Cardinal,
// Count<T>, Offset<T>) all live at higher tiers — this package
// categorically cannot import them. Int IS the right type at this
// boundary; it's the stdlib edge that other primitives wrap.
//
// Scoped per-rule disable at the leaf level rather than a tier-side
// signal in the rule itself — keeps the rule pure (no
// dependency-graph awareness) and pushes the architectural exception
// to the leaf that owns the constraint.
Lint.run(configuration: Lint.Configuration {
    Lint.Rule.Bundle.primitives
    Lint.Rule.Configuration.disable(.`int public parameter`)
})
