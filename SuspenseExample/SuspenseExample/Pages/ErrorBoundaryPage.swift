import Suspense
import SwiftUI

struct ErrorBoundaryPage: View {
    var body: some View {
        ErrorBoundary {
            Suspense {
                try FailedToFetch(value: $0, delayed: 5)
            }

            ErrorBoundary {
                Suspense {
                    try FailedToFetch(value: $0, delayed: 1)
                }
            } fallback: { _, _ in
                Text("Nested error boundary")
            }
        } fallback: { error, _ in
            Text("Parent error boundary: \(error.localizedDescription)")
        }
    }
}
