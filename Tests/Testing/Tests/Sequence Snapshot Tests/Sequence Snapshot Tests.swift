import Testing

@testable import Standard_Library_Extensions

@Suite(.serialized)
struct `Sequence - Snapshots` {

    @Test
    func `max count from unsorted`() {
        let result = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3].max(count: 5)

        snapshot(
            result.map(String.init).joined(separator: "\n"),
            as: .lines
        ) {
            """
            9
            6
            5
            5
            4
            """
        }
    }

    @Test
    func `min count from unsorted`() {
        let result = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3].min(count: 5)

        snapshot(
            result.map(String.init).joined(separator: "\n"),
            as: .lines
        ) {
            """
            1
            1
            2
            3
            3
            """
        }
    }

    @Test
    func `frequencies as sorted pairs`() {
        let result = [1, 2, 2, 3, 1, 4, 2, 3, 3, 3]
            .frequencies()
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key): \($0.value)" }
            .joined(separator: "\n")

        snapshot(result, as: .lines) {
            """
            1: 2
            2: 3
            3: 4
            4: 1
            """
        }
    }
}
