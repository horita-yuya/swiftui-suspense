import Suspense
import SwiftUI

struct ContentView: View {
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
        }
        .padding()
    }
}
