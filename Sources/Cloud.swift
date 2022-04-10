import Foundation
import Archivable
import Domains

extension Cloud where Output == Archive {
    public func search(_ string: String) async throws -> URL {
        guard let string = model.settings.search(string) else { throw Invalid.search }
        guard let url = URL(string: string) else { throw Invalid.url }
        return url
    }
    
    public func history(url: URL, title: String) async {
        guard let remote = url.remote else { return }
        
        let website = Website(id: remote, title: title)
        let comparable = website.id.comparable
        
        guard !model.bookmarks.contains(where: {
            $0.id.comparable == comparable
        }) else { return }
        
        model.history = model
            .history
            .prepending(website)
        
        await stream()
    }
    
    public func bookmark(url: URL, title: String) async {
        guard let remote = url.remote else { return }
        
        let website = Website(id: remote, title: title)
        await delete(website: website)
        
        model.bookmarks = model
            .bookmarks
            .appending(website)
        
        await stream()
    }
    
    public func delete(url: String) async {
        await delete(website: .init(id: url, title: ""))
        await stream()
    }
    
    public func policy(request: URL, from url: URL) async -> Policy.Response {
        let response = model.settings.policy(request)
        if case let .block(tracker) = response {
            model.tracking = model
                .tracking
                .with(tracker: tracker, on: url.absoluteString.domain)
            
            await stream()
        }
        return response
    }
    
    public func update(search: Search) async {
        guard search != model.settings.search else { return }
        model.settings.search = search
        await stream()
    }
    
    public func update(policy: Policy) async {
        guard policy != model.settings.policy else { return }
        model.settings.policy = policy
        await stream()
    }
    
    public func update(autoplay: Settings.Autoplay) async {
        guard autoplay != model.settings.configuration.autoplay else { return }
        model.settings.configuration.autoplay = autoplay
        await stream()
    }
    
    public func update(javascript: Bool) async {
        guard javascript != model.settings.configuration.javascript else { return }
        model.settings.configuration.javascript = javascript
        await stream()
    }
    
    public func update(popups: Bool) async {
        guard popups != model.settings.configuration.popups else { return }
        model.settings.configuration.popups = popups
        await stream()
    }
    
    public func update(location: Bool) async {
        guard location != model.settings.configuration.location else { return }
        model.settings.configuration.location = location
        await stream()
    }
    
    public func update(timers: Bool) async {
        guard timers != model.settings.configuration.timers else { return }
        model.settings.configuration.timers = timers
        await stream()
    }
    
    public func update(dark: Bool) async {
        guard dark != model.settings.configuration.dark else { return }
        model.settings.configuration.dark = dark
        await stream()
    }
    
    public func update(ads: Bool) async {
        guard ads != model.settings.configuration.ads else { return }
        model.settings.configuration.ads = ads
        await stream()
    }
    
    public func update(screen: Bool) async {
        guard screen != model.settings.configuration.screen else { return }
        model.settings.configuration.screen = screen
        await stream()
    }
    
    public func update(cookies: Bool) async {
        guard cookies != model.settings.configuration.cookies else { return }
        model.settings.configuration.cookies = cookies
        await stream()
    }
    
    public func update(http: Bool) async {
        guard http != model.settings.configuration.http else { return }
        model.settings.configuration.http = http
        await stream()
    }
    
    public func update(third: Bool) async {
        guard third != model.settings.configuration.third else { return }
        model.settings.configuration.third = third
        await stream()
    }
    
    public func forget() async {
        model.history = []
        model.tracking = .init()
        await stream()
    }
    
    private func delete(website: Website) async {
        model.history = website
            .filter(websites: model.history)
        
        model.bookmarks = website
            .filter(websites: model.bookmarks)
    }
}
