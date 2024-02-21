import Suspense
import SwiftUI

struct UserComponent: View {
    var user: User

    init(user: User?) throws {
        self.user = try resolveValue(user) {
            try await getUser()
        }
    }

    var body: some View {
        Text("Hi, my name is \(user.name).")
    }
}

struct AsyncComponent: View {
    var user: User

    init(id: String) async throws {
        self.user = try await getUser()
    }

    var body: some View {
        Text("My name is \(user.name) from AsyncComponent")
    }
}

struct ErrorComponent: View {
    enum UserError: Error {
        case notFound
    }

    var user: User

    init(user: User?) throws {
        self.user = try resolveValue(user) {
            try await Task.sleep(nanoseconds: 4_000_000_000)

            throw UserError.notFound
        }
    }

    var body: some View {
        Text("Never comes here")
    }
}

struct TerribleErrorComponent: View {
    enum UserError: Error {
        case notFound
    }

    var user: User

    init(user: User?) throws {
        self.user = try resolveValue(user) {
            try await Task.sleep(nanoseconds: 6_000_000_000)

            throw UserError.notFound
        }
    }

    var body: some View {
        Text("Never comes here")
    }
}

struct Layout: View {
    var children: AnyView

    init(@ViewBuilder children: () throws -> some View) throws {
        self.children = try AnyView(children())
    }

    var body: some View {
        VStack {
            Text("Header")
            children
        }
    }
}
