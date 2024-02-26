Based on your code samples and the inspiration from React's Suspense, here's a simple README.md for your `swiftui-suspense` library:

---

# SwiftUI-Suspense

`swiftui-suspense` is a Swift library inspired by React's Suspense, designed to streamline asynchronous data fetching and component rendering in SwiftUI applications. It introduces a new way to handle asynchronous operations within your SwiftUI views, making your code cleaner and more readable.

## Features

- **Suspense Handling:** Easily manage async tasks with the `Suspense` view wrapper.
- **Fallback Support:** Provide a fallback view to display while waiting for async tasks to complete.
- **Component Reusability:** Simplify your view hierarchy by encapsulating async logic within reusable components.
- **Error Handling**: With the newly implemented `ErrorBoundary`, SwiftUI Suspense now provides a way to catch and handle errors gracefully within your views.

## Installation

To add `swiftui-suspense` to your SwiftUI project, simply add the following dependency to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/horita-yuya/swiftui-suspense.git", from: "2.8.0")
]
```

## Usage

### Basic Usage

Wrap your view components that require asynchronous data fetching with `Suspense`, and provide a fallback view to display while the data is loading.

To resolve passed optional argument, use `use` function defined in Suspense module.

```swift
import Suspense
import SwiftUI

struct ComponentA: View {
    var name: String

    init(name: String?) throws {
        self.name = try use(name) {
            try await Task.sleep(nanoseconds: 2_000_000_000)

            return "My name is Suspense!"
        }
    }

    var body: some View {
        Text("\(name)")
    }
}


struct ContentView: View {
    var body: some View {
        VStack {
            Suspense { name in
                try ComponentA(name: name)
            }
        }
    }
}
```

### Advanced Usage

[here](https://github.com/horita-yuya/swiftui-suspense/blob/main/docs/ADVANCED_USAGE.md)

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue if you have suggestions or encounter any problems.

## License

`swiftui-suspense` is released under the MIT license. See [LICENSE](LICENSE) for more information.

---

This README is concise and to the point, focusing on the key aspects of your library. Adjust the URLs, license information, and any specific installation or usage details according to your actual library setup and preferences.
