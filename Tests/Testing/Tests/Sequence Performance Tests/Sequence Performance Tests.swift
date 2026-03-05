import Testing

@testable import Standard_Library_Extensions

@Suite(.serialized)
struct `Sequence - Performance` {

    // MARK: - Aggregation Performance

    @Test(.timed(threshold: .milliseconds(60)))
    func `sum 100k elements`() {
        let numbers = Array(1...100_000)
        _ = numbers.sum()
    }

    @Test(.timed(threshold: .milliseconds(1)))
    func `product 20 elements`() {
        let numbers = Array(1...20)
        _ = numbers.product()
    }

    @Test(.timed(threshold: .milliseconds(50)))
    func `mean 100k integers`() {
        let numbers = Array(1...100_000)
        _ = numbers.mean()
    }

    @Test(.timed(threshold: .milliseconds(70)))
    func `mean 100k doubles`() {
        let numbers = Array(1...100_000).map { Double($0) }
        _ = numbers.mean()
    }

    // MARK: - Collection Operations

    @Test(.timed(threshold: .milliseconds(50)))
    func `count where 100k elements`() {
        let numbers = Array(1...100_000)
        _ = numbers.count(where: { $0.isMultiple(of: 2) })
    }

    @Test(.timed(threshold: .milliseconds(75)))
    func `frequencies 100k elements with duplicates`() {
        let numbers = Array(repeating: 1...100, count: 1000).flatMap { $0 }
        _ = numbers.frequencies()
    }

    @Test(.timed(threshold: .milliseconds(50)))
    func `isSorted 100k sorted elements`() {
        let numbers = Array(1...100_000)
        _ = numbers.isSorted()
    }

    @Test(.timed(threshold: .milliseconds(40)))
    func `isSorted 100k reversed elements`() {
        let numbers = Array((1...100_000).reversed())
        _ = numbers.isSorted()
    }

    // MARK: - max/min count Performance

    @Test(.timed(threshold: .milliseconds(120)))
    func `max count 10 from 100k`() {
        let numbers = Array(1...100_000).shuffled()
        _ = numbers.max(count: 10)
    }

    @Test(.timed(threshold: .milliseconds(100)))
    func `min count 10 from 100k`() {
        let numbers = Array(1...100_000).shuffled()
        _ = numbers.min(count: 10)
    }
}
