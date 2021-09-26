import Archivable

extension Cloud where A == Archive {
    public func search(_ search: String) async -> Int? {
        guard let search = model.settings.search(search) else { return nil }
        let id = model.index
        model.history = model.history.adding(.init(id: id, website: .init(search: search)))
        model.index += 1
        await stream()
        return id
    }
}
