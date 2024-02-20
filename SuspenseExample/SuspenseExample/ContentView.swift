import Suspense
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Please introduce yourself.")
                Suspence { name in
                    try ComponentA(name: name)
                }
            }

            Suspence { name in
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
