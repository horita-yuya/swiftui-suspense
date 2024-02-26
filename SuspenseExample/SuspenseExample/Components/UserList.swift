import Suspense
import SwiftUI

struct UserList: View {
    var users: [User]
    @Binding var selectedUser: User?

    init(users: [User]?, selectedUser: Binding<User?>) throws {
        self.users = try use(users) {
            return try await getUsers()
        }
        self._selectedUser = selectedUser
    }

    var body: some View {
        List {
            ForEach(users, id: \.self) { user in
                Button {
                    selectedUser = user
                } label: {
                    Text("\(user.name)")
                }
            }
        }
    }
}
