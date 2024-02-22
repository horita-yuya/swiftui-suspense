import SwiftUI

public struct Suspense<PAGE: View, A>: View {
    enum Component {
        case voidComponent(() async throws -> PAGE)
        case component((A?) async throws -> PAGE)
    }

    @State private var page: PAGE?
    @Environment(ErrorHandler.self) private var errorHandler: ErrorHandler?
    private var component: Component
    private var fallback: AnyView
    private var onError: ((Error) -> Void)?

    public init(
        @ViewBuilder component: @escaping () async throws -> PAGE,
        onError: ((Error) -> Void)? = nil
    ) where A == Never {
        self.component = .voidComponent(component)
        self.fallback = AnyView(ProgressView())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping () async throws -> PAGE,
        @ViewBuilder fallback: () -> some View,
        onError: ((Error) -> Void)? = nil
    ) where A == Void {
        self.component = .voidComponent(component)
        self.fallback = AnyView(fallback())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping (A?) async throws -> PAGE,
        onError: ((Error) -> Void)? = nil
    ) {
        self.component = .component(component)
        self.fallback = AnyView(ProgressView())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping (A?) throws -> PAGE,
        @ViewBuilder fallback: () -> some View,
        onError: ((Error) -> Void)? = nil
    ) {
        self.component = .component(component)
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
                        switch component {
                        case .voidComponent(let component):
                            page = try await component()
                        case .component(let component):
                            page = try await component(nil)
                        }

                    } catch Promise<A>.pending(let query) {
                        do {
                            let data = try await query()
                            switch component {
                            case .voidComponent(let component):
                                page = try await component()

                            case .component(let component):
                                page = try await component(data)
                            }

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
