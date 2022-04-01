import Foundation
import Archivable
import Domains

extension Cloud where Output == Archive {
    public func search(_ string: String) async throws -> URL {
        guard let string = model.settings.search(string) else { throw Err.Id.invalidSearch }
        await open(website: .init(id: string, title: ""))
        guard let url = URL(string: string) else { throw Err.Id.invalidURL }
        return url
    }
    
    public func open(url: URL) async {
        guard case .remote = Router.with(url: url) else { return }
        await open(website: .init(id: url.absoluteString, title: ""))
    }
    
    public func open(website: Website) async {
        model.history = model
            .history
            .adding(website)
        await stream()
    }
    
    public func bookmark(url: URL, title: String) async {
        guard case .remote = Router.with(url: url) else { return }
        
        let bookmark = Website(id: url.absoluteString, title: title)
        
        model.bookmarks = model
            .bookmarks
            .filter {
                $0.id != bookmark.id
            }
            + bookmark
        
        await stream()
    }
    
    public func update(title: String, url: URL) async {
        guard case .remote = Router.with(url: url) else { return }
        
        model.history = model
            .history
            .adding(.init(id: url.absoluteString, title: title))
        
        await stream()
    }
    
    public func delete(history: Int) async {
        model
            .history
            .remove(at: history)
        await stream()
    }
    
    public func delete(bookmark: Int) async {
        model
            .bookmarks
            .remove(at: bookmark)
        await stream()
    }
    
    public func move(bookmark: Int, to index: Int) async {
        guard bookmark != index else { return }
        
        model.bookmarks = model
            .bookmarks
            .moving(from: bookmark, to: index)
        
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
    
    public func autocomplete(search: String) async -> [Website] {
        (model.bookmarks + model.history)
            .filter(strings: search
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
                .filter {
                    !$0.isEmpty
                })
    }
    
    public func update(search: Search.Engine) async {
        guard search != model.settings.search.engine else { return }
        model.settings = model
            .settings
            .with(search: .init(engine: search))
        await stream()
    }
    
    public func update(policy: Policy) async {
        guard policy != model.settings.policy.level else { return }
        model.settings = model
            .settings
            .with(policy: Policy.with(level: policy))
        await stream()
    }
    
    public func update(autoplay: Settings.Configuration.Autoplay) async {
        await update(configuration: model
                .settings
                .configuration
                .with(autoplay: autoplay))
    }
    
    public func update(javascript: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(javascript: javascript))
    }
    
    public func update(popups: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(popups: popups))
    }
    
    public func update(location: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(location: location))
    }
    
    public func update(timers: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(timers: timers))
    }
    
    public func update(dark: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(dark: dark))
    }
    
    public func update(ads: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(ads: ads))
    }
    
    public func update(screen: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(screen: screen))
    }
    
    public func update(cookies: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(cookies: cookies))
    }
    
    public func update(http: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(http: http))
    }
    
    public func update(third: Bool) async {
        await update(configuration: model
                .settings
                .configuration
                .with(third: third))
    }
    
    public func forget() async {
        model.history = []
        #warning("forget trackers")
        await stream()
    }
    
    private func allow(domain: Domain) async {
        model.events = model.events.add(domain: domain.minimal)
        await stream()
    }
    
    private func block(history: UInt16, tracker: String) async {
//        guard let remote = website(history: history)?.access as? Access.Remote else { return }
//        model.events = model.events.block(tracker: tracker, domain: remote.domain.minimal)
//
//        await stream()
    }
    
    private func update(configuration: Settings.Configuration) async {
        guard configuration != model.settings.configuration else { return }
        model.settings = model
            .settings
            .with(configuration: configuration)
        await stream()
    }
}
