import Suspense
import SwiftUI

struct AsyncPage: View {
    @State private var selectedUser: User?

    var body: some View {
        VStack {
            Suspense {
                try await AsyncUserList {
                    selectedUser = $0
                }
            }

            if let selectedUser {
                Text("\(selectedUser.name) is selected.")
            }
        }
    }
}
