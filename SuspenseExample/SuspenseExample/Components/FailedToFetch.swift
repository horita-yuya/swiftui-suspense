import Suspense
import SwiftUI

struct FailedToFetch: View {
    var value: String

    init(value: String?, delayed: UInt64) throws {
        self.value = try use(value) {
            try await Task.sleep(nanoseconds: delayed * 1_000_000_000)
            throw ServerError.notFound
        }
    }

    var body: some View {
        EmptyView()
    }
}
