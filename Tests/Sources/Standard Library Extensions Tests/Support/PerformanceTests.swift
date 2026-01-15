// PerformanceTests.swift
// Standards Tests
//
// Top-level performance test suite
// All performance test suites are nested under this via extensions

import Test_Primitives
import Testing

@MainActor
@Suite(
    .serialized
)
struct `Performance Tests` {}
