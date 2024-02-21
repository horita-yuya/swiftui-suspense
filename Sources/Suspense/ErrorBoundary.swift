import SwiftUI

public typealias Reset = () -> Void

public struct ErrorBoundary<PAGE: View, FALLBACK: View>: View {
    var errorHandler: ErrorHandler = .init()
    var children: () -> PAGE
    var fallback: (Error, @escaping Reset) -> FALLBACK

    public init(
        @ViewBuilder children: @escaping () -> PAGE,
        @ViewBuilder fallback: @escaping (Error, @escaping Reset) -> FALLBACK
    ) {
        self.children = children
        self.fallback = fallback
    }

    public var body: some View {
        if let error = errorHandler.error {
            fallback(error) {
                self.errorHandler.error = nil
            }
        } else {
            children()
                .environment(errorHandler)
        }
    }
}
