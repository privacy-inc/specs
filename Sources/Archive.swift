import Foundation
import Archivable

public struct Archive: Arch {
    public static var version: UInt8 {
        1
    }
    
    public var timestamp: UInt32
    public internal(set) var bookmarks: [Website]
    public internal(set) var history: [Website]
    public internal(set) var trackers: Trackers
    public internal(set) var settings: Settings
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: bookmarks)
        .adding(size: UInt16.self, collection: history)
        .adding(trackers)
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        bookmarks = []
        history = []
        trackers = .init()
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
            settings = legacy.settings
            trackers = .init()
        } else {
            bookmarks = data.collection(size: UInt16.self)
            history = data.collection(size: UInt16.self)
            trackers = .init(data: &data)
            settings = .init(data: &data)
        }
    }
}
