import SwiftUI

public struct Suspense<PAGE: View, A>: View {
    typealias ThrowableComponent = (A?) throws -> PAGE
    typealias AsyncComponent = () async throws -> PAGE

    enum Component {
        case asyncComponent(AsyncComponent)
        case throwableComponent(ThrowableComponent)
    }

    enum Status {
        case pending
        case failed
        case completedAsync(PAGE)
        case completedThrowable(A)
        case completedThrowableWithNoParams(PAGE)
    }

    @State var status: Status = .pending
    @Environment(ErrorHandler.self) private var errorHandler: ErrorHandler?
    var component: Component
    var fallback: AnyView
    var onError: ((Error) -> Void)?

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
                    self.status = await resolveComponent()
                }

        case .failed:
            EmptyView()

        case .completedAsync(let page):
            page

        case .completedThrowable(let data):
            switch component {
            case .asyncComponent:
                fatalError("AsyncComponent must no be resolved as throwable")

            case .throwableComponent(let component):
                resolveThrowableComponent(component: component, data: data)
            }

        case .completedThrowableWithNoParams(let page):
            page
        }
    }

    @inline(__always)
    func resolveComponent() async -> Status {
        do {
            switch component {
            case .asyncComponent(let component):
                return .completedAsync(try await component())

            case .throwableComponent(let component):
                do {
                    return .completedThrowableWithNoParams(try component(nil))
                } catch Promise<A>.pending(let query) {
                    do {
                        let data = try await query()
                        return .completedThrowable(data)

                    } catch {
                        onError?(error)
                        errorHandler?.error = error
                        return .failed
                    }
                }
            }

        } catch {
            onError?(error)
            errorHandler?.error = error
            return .failed
        }
    }

    @inline(__always)
    func resolveThrowableComponent(component: ThrowableComponent, data: A) -> AnyView {
        do {
            return AnyView(try component(data))

        } catch {
            onError?(error)
            errorHandler?.error = error
            return fallback
        }
    }
}
