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
