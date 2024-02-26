import Suspense
import SwiftUI

struct ExampleWithInternalError: View {
    enum Error: Swift.Error {
        case `internal`
    }

    init(value: String?) throws {
        _ = try use(value) {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return "Hello"
        }

        throw Error.internal
    }

    var body: some View {
        Text("Hello")
    }
}

struct ExampleWithState: View {
    @State private var count: Int = 0

    var body: some View {
        Suspense {
            try ThrowableCounter(name: $0, count: count)
        }

        ErrorBoundary {
            Suspense {
                try ExampleWithInternalError(value: $0)
            }
        } fallback: { _, _ in
            Text("Internal error happened")
        }

        SimpleCounter(count: count)

        Button {
            count += 1
        } label: {
            Text("Click me")
        }
    }
}

private struct SimpleCounter: View {
    var count: Int

    init(count: Int) {
        self.count = count
    }

    var body: some View {
        Text("Simple counting: \(count)")
    }
}

private struct ThrowableCounter: View {
    var name: String
    var count: Int

    init(name: String?, count: Int) throws {
        self.name = try use(name) {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return "I'm ThrowableStateComponent"
        }
        self.count = count
    }

    var body: some View {
        VStack {
            Text("\(name)")
            Text("Tapped count: \(count)")
        }
    }
}
