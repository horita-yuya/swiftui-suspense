import Suspense
import SwiftUI

struct ContentView: View {
    var body: some View {
        ErrorBoundary {
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

                Suspense { user in
                    try TerribleErrorComponent(user: user)
                }

                ErrorBoundary {
                    Suspense { user in
                        try ErrorComponent(user: user)
                    }
                } fallback: { error, reset in
                    Text("Error happened")
                    Button("Reset") {
                        reset()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        } fallback: { _, _ in
            Text("Application Error Happened!!!")
        }
        .padding()
    }
}
