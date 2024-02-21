import SwiftUI

public typealias Reset = () -> Void

public struct ErrorBoundary<PAGE: View, FALLBACK: View>: View {
    @Binding var error: Error?
    var children: () -> PAGE
    var fallback: (Error, @escaping Reset) -> FALLBACK

    public init(
        error: Binding<Error?>,
        @ViewBuilder children: @escaping () -> PAGE,
        @ViewBuilder fallback: @escaping (Error, @escaping Reset) -> FALLBACK
    ) {
        self._error = error
        self.children = children
        self.fallback = fallback
    }

    public var body: some View {
        if let error = error {
            fallback(error) {
                self.error = nil
            }
        } else {
            children()
        }
    }
}
