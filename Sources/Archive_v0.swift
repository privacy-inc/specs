import Foundation
import Archivable

struct Archive_v0: Arch {
    var timestamp: UInt32
    var bookmarks: [Website]
    var history: [History]
    var cards: [Card]
    var events: Events
    var settings: Settings
    var index: UInt16
    
    var data: Data {
        .init()
        .adding(index)
        .adding(size: UInt16.self, collection: bookmarks)
        .adding(size: UInt16.self, collection: history)
        .adding(size: UInt8.self, collection: cards)
        .adding(events)
        .adding(settings)
    }
    
    init() {
        timestamp = 0
        index = 0
        bookmarks = []
        history = []
        cards = [.init(id: .trackers),
                 .init(id: .activity),
                 .init(id: .bookmarks),
                 .init(id: .history)]
        events = .init()
        settings = .init()
    }
    
    init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        index = data.number()
        bookmarks = data.collection(size: UInt16.self)
        history = data.collection(size: UInt16.self)
        cards = data.collection(size: UInt8.self)
        events = .init(data: &data)
        settings = .init(data: &data)
    }
}
