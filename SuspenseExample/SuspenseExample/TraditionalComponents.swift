import SwiftUI

struct TraditionalUserComponent: View {
    @State var user: User?

    init() {}

    var body: some View {
        if let user = user {
            Text("Hi, my name is \(user.name).")
        } else {
            ProgressView()
                .task {
                    user = try! await getUser()
                }
        }
    }
}

struct TraditionalErrorComponent: View {
    @State var user: User?
    @State var error: Error?

    init() {}

    var body: some View {
        if let error = error {
            Text("Error happend: \(error.localizedDescription)")
        } else if let user = user {
            Text("Hi, my name is \(user.name).")
        } else {
            ProgressView()
                .task {
                    do {
                        user = try await getUser()
                    } catch {
                        self.error = error
                    }
                }
        }
    }
}
