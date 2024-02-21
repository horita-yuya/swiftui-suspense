import Suspense
import SwiftUI

struct ContentView: View {
    @State var error: Error?

    var body: some View {
        VStack {
            VStack {
                Text("Please introduce yourself.")
                Suspense { user in
                    try UserComponent(user: user)
                }
            }

            Suspense { user in
                try Layout {
                    try UserComponent(user: user)
                }
            } fallback: {
                Text("Well....")
            }

            ErrorBoundary(error: $error) {
                Suspense { user in
                    try ErrorComponent(user: user)
                } onError: { error in
                    self.error = error
                }
            } fallback: { error, reset in
                Text("Error happened")
                Button("Reset") {
                    reset()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
