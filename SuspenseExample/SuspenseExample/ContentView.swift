import Suspense
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Header")
            // Main ErrorBoundary
            ErrorBoundary {
                VStack {
                    VStack {
                        Text("Please introduce yourself.")
                        Suspense { user in
                            try UserComponent(user: user)
                        }
                    }

                    // throws component can be nested
                    Suspense { user in
                        try Layout {
                            try UserComponent(user: user)
                        }
                    } fallback: {
                        Text("Well....")
                    }

                    // simple usage
                    Suspense {
                        try await AsyncComponent(id: "AAA")
                    }

                    Suspense { user in
                        try TerribleErrorComponent(user: user)
                    }

                    // Nested ErrorBoundary
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
        }
        .padding()
    }
}
