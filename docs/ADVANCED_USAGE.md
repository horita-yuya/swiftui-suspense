## Advances Usage

### [ErrorBoundary](https://github.com/horita-yuya/swiftui-suspense/blob/main/SuspenseExample/SuspenseExample/Components/FailedToFetch.swift)

You can use ErrorBoundary component or onError callback to handle errors other than internal Promise errors.

ErrorBoundary can be nested. In the following example, "Nested error boundary" message appears first. After that, "Parent error boundary" message is displayed. 

```swift
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
```

### [Fetch and State](https://github.com/horita-yuya/swiftui-suspense/blob/main/SuspenseExample/SuspenseExample/Components/UserList.swift)

Use Suspense to fetch data and update the parent state.

```swift
import SwiftUI
import Suspense

struct FetchAndStatePage: View {
    @State var selectedUser: User?
    
    var body: some View {
        VStack {
            Suspense {
                try UserList(users: $0, selectedUser: $selectedUser)
            }
            
            if let selectedUser {
                Text("\(selectedUser.name) is selected.")
            }
        }
    }
}
```

### [AsyncComponent](https://github.com/horita-yuya/swiftui-suspense/blob/main/SuspenseExample/SuspenseExample/Components/AsyncUserList.swift)

You can use an async initializer for your components.

```swift
struct AsyncPage: View {
    @State private var selectedUser: User?
    
    var body: some View {
        VStack {
            Suspense {
                try await AsyncUserList {
                    selectedUser = $0
                }
            }
            
            if let selectedUser {
                Text("\(selectedUser.name) is selected.")
            }
        }
    }
}

```

### [Throwable vs Async Component](https://github.com/horita-yuya/swiftui-suspense/blob/main/SuspenseExample/SuspenseExample/Components/Counter.swift)

One of the biggest differences between non-async throwable components and async throwable components is their re-rendering behavior.

I will show you an example using the following components.

The tasks of both of them are fetching user data and display count of it.

```swift
import SwiftUI
import Suspense

struct ThrowableCounter: View {
    var user: User
    var count: Int
    
    init(user: User?, count: Int) throws {
        self.user = try use(user) {
            try await getUser()
        }
        self.count = count
    }
    
    var body: some View {
        Text("\(user.name)'s count is \(count)")
    }
}

struct AsyncCounter: View {
    var user: User
    var count: Int
    
    init(count: Int) async throws {
        self.user = try await getUser()
        self.count = count
    }
    
    var body: some View {
        Text("\(user.name)'s count is \(count)")
    }
}
```

I use them in a page which has `count` state passed to each component.

```swift
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
``` 

In this example, only `ThrowableCounter` is updated. This is a design limitation.

Components which have an async initializer are *treated like a snapshot*.

## What if without Suspense and ErrorBoundary?

This approach requires a lot of boilerplate code.

```swift
struct TraditionalUserComponent: View {
    @State var user: User?

    init() {}

    var body: some View {
        if let user = user {
            Text("Hi, my name is \(user.name).")
        } else {
            ProgressView()
                .task {
                    user = try! await getUser()
                }
        }
    }
}

struct TraditionalErrorComponent: View {
    @State var user: User?
    @State var error: Error?

    init() {}

    var body: some View {
        if let error = error {
            Text("Error happend: \(error.localizedDescription)")
        } else if let user = user {
            Text("Hi, my name is \(user.name).")
        } else {
            ProgressView()
                .task {
                    do {
                        user = try await getUser()
                    } catch {
                        self.error = error
                    }
                }
        }
    }
}

```
