enum Promise<A>: Error {
    case pending(query: () async throws -> A)
}
