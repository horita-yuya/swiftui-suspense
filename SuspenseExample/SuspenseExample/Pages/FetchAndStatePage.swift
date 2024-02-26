import Suspense
import SwiftUI

struct FetchAndStatePage: View {
    @State var selectedUser: User?

    var body: some View {
        VStack {
            Suspense {
                try UserList(users: $0, selectedUser: $selectedUser)
            }

            if let selectedUser {
                Text("\(selectedUser.name) is selected.")
            }
        }
    }
}
