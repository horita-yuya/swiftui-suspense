import Suspense
import SwiftUI

struct AsyncUserList: View {
    var users: [User]
    var onSelected: (User) -> Void

    init(onSelected: @escaping (User) -> Void) async throws {
        self.users = try await getUsers()
        self.onSelected = onSelected
    }

    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                Button {
                    onSelected(user)
                } label: {
                    Text("\(user.name)")
                }
            }
        }
    }
}
