import Foundation
import Archivable

public struct Archive: Arch {
    public static var version: UInt8 {
        1
    }
    
    public var timestamp: UInt32
    public internal(set) var tracking: Tracking
    public internal(set) var settings: Settings
    var bookmarks: [Website]
    var history: [Website]

    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: bookmarks)
        .adding(size: UInt16.self, collection: history)
        .adding(tracking)
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        bookmarks = []
        history = []
        tracking = .init()
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == 0 {
            let legacy = await Archive_v0(version: 0, timestamp: 0, data: data)
            bookmarks = legacy
                .bookmarks
                .map {
                    .init(id: $0.access.value, title: $0.title)
                }
            history = legacy
                .history
                .filter {
                    guard case .remote = $0.website.access.key else { return false }
                    return true
                }
                .map {
                    .init(id: $0.website.access.value, title: $0.website.title)
                }
            settings = .init()
            settings.search = legacy.settings.search
            settings.policy = legacy.settings.policy
            settings.configuration.autoplay = legacy.settings.configuration.autoplay
            settings.configuration.javascript = legacy.settings.configuration.javascript
            settings.configuration.popups = legacy.settings.configuration.popups
            settings.configuration.location = legacy.settings.configuration.location
            settings.configuration.timers = legacy.settings.configuration.timers
            settings.configuration.dark = legacy.settings.configuration.dark
            settings.configuration.ads = legacy.settings.configuration.ads
            settings.configuration.screen = legacy.settings.configuration.screen
            settings.configuration.cookies = legacy.settings.configuration.cookies
            settings.configuration.http = legacy.settings.configuration.http
            settings.configuration.third = legacy.settings.configuration.third
            tracking = .init()
        } else {
            bookmarks = data.collection(size: UInt16.self)
            history = data.collection(size: UInt16.self)
            tracking = .init(data: &data)
            settings = .init(data: &data)
        }
    }
    
    public func websites(filter: String) -> [Website] {
        { websites, filters in
            filters.isEmpty ? websites : websites.filter(strings: filters)
        } (bookmarks + history, filter
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: " ")
            .filter {
                !$0.isEmpty
            })
    }
}
