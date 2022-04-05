import Foundation
import Archivable
import Domains

extension Cloud where Output == Archive {
    public func search(_ string: String) async throws -> URL {
        guard let string = model.settings.search(string) else { throw Fail.Invalid.search }
        guard let url = URL(string: string) else { throw Fail.Invalid.url }
        return url
    }
    
    public func history(url: URL, title: String) async {
        guard let remote = url.remote else { return }
        
        let website = Website(id: remote, title: title)
        let id = website.id.historical
        
        guard !model.bookmarks.contains(where: {
            $0.id.historical == id
        }) else { return }
        
        model.history = model
            .history
            .prepending(website)
        
        await stream()
    }
    
    public func bookmark(url: URL, title: String) async {
        guard let remote = url.remote else { return }
        
        let website = Website(id: remote, title: title)
        
        model.history = model
            .history
            .filter(website)
        
        model.bookmarks = model
            .bookmarks
            .appending(website)
        
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
    
    public func policy(request: URL, from url: URL) async -> Policy.Response {
        let response = model.settings.policy(request)
        if case let .block(tracker) = response {
            model.tracking = model
                .tracking
                .with(tracker: tracker, on: url.absoluteString.domainMinimal)
            
            await stream()
        }
        return response
    }
    
    public func list(filter: String) async -> [Website] {
        { websites, filters in
            filters.isEmpty ? websites : websites.filter(strings: filters)
        } (model.bookmarks + model.history, filter
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .filter {
                !$0.isEmpty
            })
    }
    
    public func update(search: Search) async {
        guard search != model.settings.search else { return }
        model.settings = model
            .settings
            .with(search: search)
        await stream()
    }
    
    public func update(policy: Policy) async {
        guard policy != model.settings.policy else { return }
        model.settings = model
            .settings
            .with(policy: policy)
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
        model.tracking = .init()
        await stream()
    }
    
    private func update(configuration: Settings.Configuration) async {
        guard configuration != model.settings.configuration else { return }
        model.settings = model
            .settings
            .with(configuration: configuration)
        await stream()
    }
}
