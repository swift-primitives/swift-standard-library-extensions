import Testing

@testable import Standard_Library_Extensions

// MARK: - Sendable Fixtures

actor Counter {
    var count = 0

    func increment() { count += 1 }
    func value() -> Int { count }

    enum Failure: Error { case belowZero }

    func decrement() throws(Failure) {
        guard count > 0 else { throw .belowZero }
        count -= 1
    }
}

/// A second actor that can observe a Counter.
actor Observer {
    func read(_ counter: Counter) async -> Int {
        await counter.value()
    }
}

// MARK: - Non-Sendable Fixtures

final class Box {
    var value: Int
    init(_ value: Int) { self.value = value }
}

actor Holder {
    let stored = Box(42)
    func getStored() -> Box { stored }
}

// MARK: - Sync run

@Suite
struct `Actor - run sync` {

    @Test
    func `Synchronous multi-step access`() async {
        let counter = Counter()

        await counter.run { counter in
            counter.increment()
            counter.increment()
            counter.increment()
            #expect(counter.value() == 3)
        }
    }

    @Test
    func `Returns Sendable value across isolation boundary`() async {
        let counter = Counter()

        let result = await counter.run { counter in
            counter.increment()
            return counter.value()
        }

        #expect(result == 1)
    }

    @Test
    func `Propagates typed error`() async {
        let counter = Counter()

        await #expect(throws: Counter.Failure.belowZero) {
            try await counter.run { counter in
                try counter.decrement()
            }
        }
    }

    @Test
    func `No interleaving during run`() async {
        let counter = Counter()

        await counter.run { counter in
            for _ in 0..<100 {
                counter.increment()
            }
        }

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    await counter.run { counter in
                        let before = counter.value()
                        counter.increment()
                        let after = counter.value()
                        #expect(after - before == 1)
                    }
                }
            }
        }

        #expect(await counter.value() == 110)
    }
}

// MARK: - Async run

@Suite
struct `Actor - run async` {

    @Test
    func `Cross-actor call inside run`() async {
        let counter = Counter()
        let observer = Observer()

        await counter.run { counter in
            counter.increment()
            counter.increment()

            // await in body → async overload selected
            let observed = await observer.read(counter)
            #expect(observed == 2)
        }
    }

    @Test
    func `Returns value from async closure`() async {
        let counter = Counter()
        let observer = Observer()

        let result = await counter.run { counter in
            counter.increment()
            return await observer.read(counter)
        }

        #expect(result == 1)
    }

    @Test
    func `Propagates typed error from async closure`() async {
        let counter = Counter()
        let observer = Observer()

        await #expect(throws: Counter.Failure.belowZero) {
            try await counter.run { counter in
                // Force async overload via cross-actor call
                _ = await observer.read(counter)
                try counter.decrement()
            }
        }
    }
}

// MARK: - Sending return

@Suite
struct `Actor - sending return` {

    @Test
    func `Non-Sendable value constructed inline`() async {
        let holder = Holder()

        let box = await holder.run { _ in
            Box(7)
        }

        #expect(box.value == 7)
    }

    @Test
    func `Non-Sendable tuple constructed inline`() async {
        let holder = Holder()

        let (a, b) = await holder.run { _ in
            (Box(1), Box(2))
        }

        #expect(a.value == 1)
        #expect(b.value == 2)
    }

    @Test
    func `Non-Sendable array constructed inline`() async {
        let holder = Holder()

        let boxes = await holder.run { _ in
            (0..<5).map { Box($0) }
        }

        #expect(boxes.count == 5)
        #expect(boxes[3].value == 3)
    }

    // NOTE: The following does NOT compile (correctly):
    //
    //   await holder.run { holder in holder.getStored() }
    //
    // Error: returning 'holder'-isolated 'holder.getStored' as a
    //        'sending' result risks causing data races
    //
    // The compiler correctly rejects returning values obtained from
    // actor-isolated methods, because it cannot prove they are
    // disconnected from the actor's state.
}
