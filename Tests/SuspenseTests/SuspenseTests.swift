import SwiftUI
import Testing

@testable import Suspense

struct SuspenseTests {

    enum TestError: Error {
        case general
    }

    private struct UseComp: View {
        init(value: String?, throwError: Bool) throws {
            _ = try use(value) {
                if throwError {
                    throw TestError.general
                } else {
                    return "value"
                }
            }
        }

        var body: some View {
            EmptyView()
        }
    }

    private struct NothingThrownComp: View {
        init(value: String?) throws {}

        var body: some View {
            EmptyView()
        }
    }

    private struct AsyncComp: View {
        init(throwError: Bool) async throws {
            if throwError {
                throw TestError.general
            }
        }

        var body: some View {
            EmptyView()
        }
    }

    private struct AlwaysErrorComp: View {
        init() throws {
            throw TestError.general
        }

        var body: some View {
            EmptyView()
        }
    }

    @Test
    func throwPromiseOrError() async {
        let throwPromise = Suspense {
            try UseComp(value: $0, throwError: false)
        }

        let throwErrorInUse = Suspense {
            try UseComp(value: $0, throwError: true)
        }

        let throwErrorInInit = Suspense {
            try AlwaysErrorComp()
        }

        let statusPromise = await throwPromise.resolveComponent()
        let statusErrorInUse = await throwErrorInUse.resolveComponent()
        let statusErrorInInit = await throwErrorInInit.resolveComponent()
        #expect(statusPromise.desc == "completedThrowable")
        #expect(statusErrorInUse.desc == "failed")
        #expect(statusErrorInInit.desc == "failed")
    }

    @Test
    func throwablePromiseButNothingThrown() async {
        let nothingThrown = Suspense {
            try NothingThrownComp(value: $0)
        }

        let status = await nothingThrown.resolveComponent()
        #expect(status.desc == "completedThrowableWithNoParams")
    }

    @Test
    func resolveAsync() async {
        let async1 = Suspense {
            try await AsyncComp(throwError: false)
        }

        let status1 = await async1.resolveComponent()
        #expect(status1.desc == "completedAsync")

        let async2 = Suspense {
            try await AsyncComp(throwError: true)
        }

        let status2 = await async2.resolveComponent()
        #expect(status2.desc == "failed")
    }
}

extension Suspense.Status {
    fileprivate var desc: String {
        switch self {
        case .pending: "pending"
        case .failed: "failed"
        case .completedAsync: "completedAsync"
        case .completedThrowable: "completedThrowable"
        case .completedThrowableWithNoParams: "completedThrowableWithNoParams"
        }
    }
}
