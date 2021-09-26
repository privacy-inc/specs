import Archivable

extension Cloud where A == Archive {
    public func search(_ string: String) async throws -> Int {
        let id = model.index
        try await search(string, history: id)
        model.index += 1
        return id
    }
    
    public func search(_ string: String, history: Int) async throws {
        guard let string = model.settings.search(string) else { throw Err.invalidSearch }
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: .init(search: string)))
        await stream()
    }
}
