@inline(__always)
public func use<A>(_ pendingA: A?, query: @escaping () async throws -> A) throws -> A {
    if let value = pendingA {
        return value
    } else {
        throw Promise<A>.pending(query: query)
    }
}
