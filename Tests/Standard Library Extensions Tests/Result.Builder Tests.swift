import Testing

@testable import Standard_Library_Extensions

typealias StdResult<S, F: Error> = Swift.Result<S, F>

@Suite
struct `Result.Builder Tests` {

    enum TestError: Error, Equatable {
        case first
        case second
        case third
    }

    @Suite
    struct `Result.Builder (First Success)` {

        @Test
        func `Returns first success`() {
            let result: StdResult<Int, TestError> = .first {
                StdResult<Int, TestError>.failure(.first)
                StdResult<Int, TestError>.success(42)
                StdResult<Int, TestError>.success(100)
            }

            #expect(result == .success(42))
        }

        @Test
        func `Returns last failure when all fail`() {
            let result: StdResult<Int, TestError> = .first {
                StdResult<Int, TestError>.failure(.first)
                StdResult<Int, TestError>.failure(.second)
                StdResult<Int, TestError>.failure(.third)
            }

            #expect(result == .failure(.third))
        }

        @Test
        func `Direct success value`() {
            let result: StdResult<Int, TestError> = .first {
                42
            }

            #expect(result == .success(42))
        }

        @Test
        func `If-else first branch`() {
            let condition = true
            let result: StdResult<String, TestError> = .first {
                if condition {
                    StdResult<String, TestError>.success("first")
                } else {
                    StdResult<String, TestError>.success("second")
                }
            }

            #expect(result == .success("first"))
        }

        @Test
        func `If-else second branch`() {
            let condition = false
            let result: StdResult<String, TestError> = .first {
                if condition {
                    StdResult<String, TestError>.success("first")
                } else {
                    StdResult<String, TestError>.success("second")
                }
            }

            #expect(result == .success("second"))
        }
    }

    @Suite
    struct `Result.AllBuilder (Collect All)` {

        @Test
        func `Collects all successes`() {
            let result = StdResult<Int, TestError>.all {
                StdResult<Int, TestError>.success(1)
                StdResult<Int, TestError>.success(2)
                StdResult<Int, TestError>.success(3)
            }

            #expect(result == .success([1, 2, 3]))
        }

        @Test
        func `Fails on first error`() {
            let result = StdResult<Int, TestError>.all {
                StdResult<Int, TestError>.success(1)
                StdResult<Int, TestError>.failure(.second)
                StdResult<Int, TestError>.success(3)
            }

            #expect(result == .failure(.second))
        }

        @Test
        func `Empty block returns empty array`() {
            let result = StdResult<Int, TestError>.all {
            }

            #expect(result == .success([]))
        }

        @Test
        func `Direct values are wrapped`() {
            let result = StdResult<Int, TestError>.all {
                1
                2
                3
            }

            #expect(result == .success([1, 2, 3]))
        }

        @Test
        func `For loop collects all`() {
            let result = StdResult<Int, TestError>.all {
                for i in 1...3 {
                    StdResult<Int, TestError>.success(i * 10)
                }
            }

            #expect(result == .success([10, 20, 30]))
        }

        @Test
        func `For loop fails on error`() {
            let result = StdResult<Int, TestError>.all {
                for i in 1...3 {
                    if i == 2 {
                        StdResult<Int, TestError>.failure(.second)
                    } else {
                        StdResult<Int, TestError>.success(i * 10)
                    }
                }
            }

            #expect(result == .failure(.second))
        }

        @Test
        func `Conditional inclusion - some`() {
            let include = true
            let result = StdResult<Int, TestError>.all {
                StdResult<Int, TestError>.success(1)
                if include {
                    StdResult<Int, TestError>.success(2)
                }
                StdResult<Int, TestError>.success(3)
            }

            #expect(result == .success([1, 2, 3]))
        }

        @Test
        func `Conditional inclusion - none`() {
            let include = false
            let result = StdResult<Int, TestError>.all {
                StdResult<Int, TestError>.success(1)
                if include {
                    StdResult<Int, TestError>.success(2)
                }
                StdResult<Int, TestError>.success(3)
            }

            #expect(result == .success([1, 3]))
        }
    }

    @Suite
    struct `Static Method Tests` {

        @Test
        func `buildExpression success value`() {
            let result = StdResult<Int, TestError>.Builder.First.buildExpression(42)
            #expect(result == .success(42))
        }

        @Test
        func `buildExpression result passthrough`() {
            let input = StdResult<Int, TestError>.failure(.first)
            let result = StdResult<Int, TestError>.Builder.First.buildExpression(input)
            #expect(result == .failure(.first))
        }

        @Test
        func `buildPartialBlock accumulated success keeps success`() {
            let result = StdResult<Int, TestError>.Builder.First.buildPartialBlock(
                accumulated: .success(42),
                next: .success(100)
            )
            #expect(result == .success(42))
        }

        @Test
        func `buildPartialBlock accumulated failure tries next`() {
            let result = StdResult<Int, TestError>.Builder.First.buildPartialBlock(
                accumulated: .failure(.first),
                next: .success(100)
            )
            #expect(result == .success(100))
        }

        @Test
        func `buildEither first`() {
            let result = StdResult<Int, TestError>.Builder.First.buildEither(first: .success(42))
            #expect(result == .success(42))
        }

        @Test
        func `buildEither second`() {
            let result = StdResult<Int, TestError>.Builder.First.buildEither(second: .failure(.second))
            #expect(result == .failure(.second))
        }
    }

    @Suite
    struct `Limited Availability` {

        @Test
        func `Limited availability passthrough - first`() {
            let result: StdResult<Int, TestError> = .first {
                StdResult<Int, TestError>.failure(.first)
                if #available(macOS 26, iOS 26, *) {
                    StdResult<Int, TestError>.success(42)
                }
            }
            #expect(result == .success(42))
        }

        @Test
        func `Limited availability passthrough - all`() {
            let result = StdResult<Int, TestError>.all {
                StdResult<Int, TestError>.success(1)
                if #available(macOS 26, iOS 26, *) {
                    StdResult<Int, TestError>.success(2)
                }
            }
            #expect(result == .success([1, 2]))
        }
    }
}
