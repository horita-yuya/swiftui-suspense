import SwiftUI

public struct Suspense<PAGE: View, A>: View {
    @State private var page: PAGE?
    @Environment(ErrorHandler.self) private var errorHandler: ErrorHandler?
    private var component: (A?) throws -> PAGE
    private var fallback: AnyView
    private var onError: ((Error) -> Void)?

    public init(
        @ViewBuilder component: @escaping (A?) throws -> PAGE,
        onError: ((Error) -> Void)? = nil
    ) {
        self.component = component
        self.fallback = AnyView(ProgressView())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping (A?) throws -> PAGE,
        @ViewBuilder fallback: () -> some View,
        onError: ((Error) -> Void)? = nil
    ) {
        self.component = component
        self.fallback = AnyView(fallback())
        self.onError = onError
    }

    public var body: some View {
        if let page = page {
            page
        } else {
            fallback
                .task {
                    do {
                        self.page = try component(nil)
                    } catch Promise<A>.pending(let query) {
                        do {
                            let data = try await query()
                            self.page = try component(data)
                        } catch {
                            onError?(error)
                            errorHandler?.error = error
                        }
                    } catch {
                        onError?(error)
                        errorHandler?.error = error
                    }
                }
        }
    }
}
