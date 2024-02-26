import Suspense
import SwiftUI

struct ThrowableCounter: View {
    var user: User
    var count: Int

    init(user: User?, count: Int) throws {
        self.user = try use(user) {
            try await getUser()
        }
        self.count = count
    }

    var body: some View {
        Text("\(user.name)'s count is \(count)")
    }
}

struct AsyncCounter: View {
    var user: User
    var count: Int

    init(count: Int) async throws {
        self.user = try await getUser()
        self.count = count
    }

    var body: some View {
        Text("\(user.name)'s count is \(count)")
    }
}
