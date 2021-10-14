import Foundation
import Archivable
import Domains

extension Cloud where Output == Archive {
    public func search(_ string: String) async throws -> UInt16 {
        let id = model.index
        try await search(string, history: id)
        model.index += 1
        return id
    }
    
    public func search(_ string: String, history: UInt16) async throws {
        guard let string = model.settings.search(string) else { throw Err.ID.invalidSearch }
        guard let url = URL(string: string) else { throw Err.ID.invalidURL }
        await add(website: .init(url: url), history: history)
    }
    
    public func open(access: AccessType) async -> UInt16 {
        var id = id(access: access)
        
        if id == nil {
            id = model.index
            model.index += 1
        }
        
        await add(website: .init(access: access), history: id!)
        return id!
    }
    
    public func open(url: URL) async -> UInt16 {
        let access = Access.with(url: url)
        var id = id(access: access)
        
        if id == nil {
            id = model.index
            model.index += 1
        }
        
        await add(website: .init(access: access), history: id!)
        return id!
    }
    
    public func bookmark(history: UInt16) async {
        let bookmark = website(history: history)
        
        model.bookmarks = model
            .bookmarks
            .filter {
                $0.access.value != bookmark.access.value
            }
            + bookmark
        
        await stream()
    }
    
    public func update(title: String, history: UInt16) async {
        let original = website(history: history)
        
        guard original.title != title else { return }
        
        let updated = original
            .with(title: title)
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: updated))
        await stream()
    }
    
    public func update(url: URL, history: UInt16) async {
        let original = website(history: history)
        
        guard original.access.value != url.absoluteString else { return }
        
        let updated = original
            .with(access: Access.with(url: url))
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: updated))
        await stream()
    }
    
    public func move(bookmark: Int, to index: Int) async {
        guard bookmark != index else { return }
        
        model.bookmarks = model
            .bookmarks
            .moving(from: bookmark, to: index)
        
        await stream()
    }
    
    public func delete(history: UInt16) async {
        model.history = model
            .history
            .dropping(history)
        await stream()
    }
    
    public func delete(bookmark: Int) async {
        model
            .bookmarks
            .remove(at: bookmark)
        await stream()
    }
    
    public func turn(card: Card.ID, state: Bool) async {
        guard model.cards.first(where: { $0.id == card })?.state != state else { return }
        
        model.cards = model
            .cards
            .mutating {
                $0.id == card
            } transform: {
                $0.with(state: state)
            }
        await stream()
    }
    
    public func move(card: Card.ID, index: Int) async {
        guard model.cards.firstIndex(where: { $0.id == card }) != index else { return }
        
        model.cards = model
            .cards
            .moving(criteria: {
                $0.id == card
            }, to: index)
        await stream()
    }
    
    public func policy(history: UInt16, url: URL) -> Policy.Result {
        {
            switch $0.event {
            case let .allow(domain):
                Task
                    .detached(priority: .utility) {
                        await self.allow(domain: domain)
                    }
            case let .block(tracker):
                Task
                    .detached(priority: .utility) {
                        await self.block(history: history, tracker: tracker)
                    }
            case .none:
                break
            }
            return $0.result
        } (model.settings.policy(url))
    }
    
    public func website(history: UInt16) -> Website {
        model
            .history
            .first { $0.id == history }!
            .website
    }
    
    private func id(access: AccessType) -> UInt16? {
        model
            .history
            .first {
                $0.website.access.value == access.value
            }?.id
    }
    
    private func add(website: Website, history: UInt16) async {
        model.history = model
            .history
            .dropping(history)
            .adding(.init(id: history, website: website))
        await stream()
    }
    
    private func allow(domain: Domain) async {
        model.events = model.events.add(domain: domain.minimal)
        await stream()
    }
    
    private func block(history: UInt16, tracker: String) async {
        guard let remote = website(history: history).access as? Access.Remote else { return }
        model.events = model.events.block(tracker: tracker, domain: remote.domain.minimal)
        
        await stream()
    }
}
