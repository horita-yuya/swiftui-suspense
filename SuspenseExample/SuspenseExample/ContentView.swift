import Suspense
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Please introduce yourself.")
                Suspense { name in
                    try ComponentA(name: name)
                }
            }

            Suspense { name in
                try ComponentB {
                    try ComponentA(name: name)
                }
            } fallback: {
                Text("Well....")
            }
        }
        .padding()
    }
}
