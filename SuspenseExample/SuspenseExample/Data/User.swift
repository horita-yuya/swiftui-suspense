struct User: Equatable, Hashable {
    var name: String
}

func getUser() async throws -> User {
    try await Task.sleep(nanoseconds: 1_000_000_000)

    return .init(name: "Alice")
}

func getUsers() async throws -> [User] {
    try await Task.sleep(nanoseconds: 1_000_000_000)

    return [
        .init(name: "Alice"),
        .init(name: "Bob"),
        .init(name: "Charlie"),
    ]
}
