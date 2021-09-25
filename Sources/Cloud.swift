import Archivable

extension Cloud where A == Archive {
    public func search(_ search: String) async -> Int? {
        model.settings.search(search: search)
            .map {
                let id = model.index
                model.history.insert(.init(id: id, website: .init(search: $0)), at: 0)
                model.index += 1
                return id
            }
    }
}
