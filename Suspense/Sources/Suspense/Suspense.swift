import SwiftUI

public struct Suspence<PAGE: View, A>: View {
    @State private var page: PAGE?
    private var component: (A?) throws -> PAGE
    private var fallback: AnyView
    
    init(@ViewBuilder component: @escaping (A?) throws -> PAGE) {
        self.component = component
        self.fallback = AnyView(ProgressView())
    }
    
    init(@ViewBuilder component: @escaping (A?) throws -> PAGE, @ViewBuilder fallback: () -> some View) {
        self.component = component
        self.fallback = AnyView(fallback())
    }
    
    public var body: some View {
        if let page = page {
            page
        } else {
            fallback
                .onAppear {
                    do {
                        self.page = try component(nil)
                    } catch Promise<A>.pending(let query) {
                        Task {
                            let data = try await query()
                            self.page = try component(data)
                        }
                    } catch {
                    }
                }
        }
    }
}
