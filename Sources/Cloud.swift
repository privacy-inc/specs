import Foundation
import Archivable

extension Cloud where Output == Archive {
    public func search(_ string: String) async throws -> Int {
        let id = model.index
        try await search(string, history: id)
        model.index += 1
        return id
    }
    
    public func search(_ string: String, history: Int) async throws {
        guard let string = model.settings.search(string) else { throw Err.invalidSearch }
        await add(website: .init(search: string), history: history)
    }
    
    public func open(url: URL) async -> Int {
        let access = Access.with(url: url)
        var id = model
            .history
            .first {
                $0.website.access.value == access.value
            }?.id
        
        if id == nil {
            id = model.index
            model.index += 1
        }
        
        await add(website: .init(access: access), history: id!)
        return id!
    }
    
    public func bookmark(history: Int) async {
        let bookmark = model
            .history
            .first { $0.id == history }!
            .website
        
        model.bookmarks = model
            .bookmarks
            .filter {
                $0.access.value != bookmark.access.value
            }
            + bookmark
        
        await stream()
    }
    
    public func update(title: String, history: Int) async {
        let original = model
            .history
            .first { $0.id == history }!
            .website
        
        guard original.title != title else { return }
        
        let updated = original
            .with(title: title)
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: updated))
        await stream()
    }
    
    public func update(url: URL, history: Int) async {
        let original = model
            .history
            .first { $0.id == history }!
            .website
        
        guard original.access.value != url.absoluteString else { return }
        
        let updated = original
            .with(access: Access.with(url: url))
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: updated))
        await stream()
    }
    
    private func add(website: Website, history: Int) async {
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: website))
        await stream()
    }
}
