import Suspense
import SwiftUI

struct ComponentA: View {
    var name: String

    init(name: String?) throws {
        self.name = try resolveValue(name) {
            try await Task.sleep(nanoseconds: 2_000_000_000)

            return "My name is Suspence!"
        }
    }

    var body: some View {
        Text("\(name)")
    }
}

struct ComponentB: View {
    var children: AnyView

    init(@ViewBuilder children: () throws -> some View) throws {
        self.children = try AnyView(children())
    }

    var body: some View {
        VStack {
            Text("Nested Components will be resolved")
            children
        }
    }
}
