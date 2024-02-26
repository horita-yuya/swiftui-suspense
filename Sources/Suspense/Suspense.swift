import SwiftUI

public struct Suspense<PAGE: View, A>: View {
    fileprivate typealias ThrowableComponent = (A?) throws -> PAGE
    fileprivate typealias AsyncComponent = () async throws -> PAGE

    private enum Component {
        case asyncComponent(AsyncComponent)
        case throwableComponent(ThrowableComponent)
    }

    private enum Status {
        case pending
        case completedAsync(PAGE)
        case completedThrowable(A)
    }

    @State private var status: Status = .pending
    @Environment(ErrorHandler.self) private var errorHandler: ErrorHandler?
    private var component: Component
    private var fallback: AnyView
    private var onError: ((Error) -> Void)?

    public init(
        @ViewBuilder component: @escaping () async throws -> PAGE,
        onError: ((Error) -> Void)? = nil
    ) where A == Never {
        self.component = .asyncComponent(component)
        self.fallback = AnyView(ProgressView())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping () async throws -> PAGE,
        @ViewBuilder fallback: () -> some View,
        onError: ((Error) -> Void)? = nil
    ) where A == Void {
        self.component = .asyncComponent(component)
        self.fallback = AnyView(fallback())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping (A?) throws -> PAGE,
        onError: ((Error) -> Void)? = nil
    ) {
        self.component = .throwableComponent(component)
        self.fallback = AnyView(ProgressView())
        self.onError = onError
    }

    public init(
        @ViewBuilder component: @escaping (A?) throws -> PAGE,
        @ViewBuilder fallback: () -> some View,
        onError: ((Error) -> Void)? = nil
    ) {
        self.component = .throwableComponent(component)
        self.fallback = AnyView(fallback())
        self.onError = onError
    }

    public var body: some View {
        switch status {
        case .pending:
            fallback
                .task {
                    do {
                        switch component {
                        case .asyncComponent(let component):
                            status = .completedAsync(try await component())

                        case .throwableComponent(let component):
                            do {
                                _ = try component(nil)
                            } catch Promise<A>.pending(let query) {
                                do {
                                    let data = try await query()
                                    status = .completedThrowable(data)

                                } catch {
                                    onError?(error)
                                    errorHandler?.error = error
                                }
                            }
                        }
                    } catch {
                        onError?(error)
                        errorHandler?.error = error
                    }
                }
        case .completedAsync(let page):
            page

        case .completedThrowable(let data):
            switch component {
            case .asyncComponent:
                EmptyView()
                    .onAppear {
                        assertionFailure("AsyncComponent must not be completed as throwable")
                    }

            case .throwableComponent(let component):
                resolveThrowableComponent(component: component, data: data)
            }
        }
    }

    private func resolveThrowableComponent(component: ThrowableComponent, data: A) -> AnyView {
        do {
            return AnyView(try component(data))
        } catch {
            onError?(error)
            errorHandler?.error = error
            return fallback
        }
    }
}
