import Suspense
import SwiftUI

struct ThrowableVsAsyncPage: View {
    @State var count: Int = 0

    var body: some View {
        VStack {
            VStack {
                Suspense {
                    try ThrowableCounter(user: $0, count: count)
                }

                Suspense {
                    try await AsyncCounter(count: count)
                }
            }

            Button {
                count += 1
            } label: {
                Text("Tap ME")
            }
        }
    }
}
