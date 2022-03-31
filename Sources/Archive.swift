import Foundation
import Archivable

public struct Archive: Arch {
    public static var version: UInt8 {
        1
    }
    
    public var timestamp: UInt32
    public internal(set) var bookmarks: [Website]
    public internal(set) var history: [Website]
    public internal(set) var events: Events
    public internal(set) var settings: Settings
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, collection: bookmarks)
        .adding(size: UInt16.self, collection: history)
        .adding(events)
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        bookmarks = []
        history = []
        events = .init()
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        if version == 0 {
            let legacy = await Archive_v0(version: 0, timestamp: 0, data: data)
//            bookmarks = legacy.bookmarks
//            history = legacy.history
            bookmarks = []
            history = []
            settings = legacy.settings
            events = legacy.events
        } else {
            bookmarks = data.collection(size: UInt16.self)
            history = data.collection(size: UInt16.self)
            events = .init(data: &data)
            settings = .init(data: &data)
        }
    }
}
