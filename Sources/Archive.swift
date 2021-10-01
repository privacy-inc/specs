import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var bookmarks: [Website]
    public internal(set) var history: [History]
    public internal(set) var cards: [Cards]
    public internal(set) var settings: Settings
    var index: Int
    
    public var data: Data {
        .init()
        .adding(UInt16(index))
        .adding(UInt16.self, collection: bookmarks)
        .adding(UInt16.self, collection: history)
        .adding(UInt8(cards.count))
        .adding(cards.map(\.rawValue))
        .adding(settings)
    }
    
    public init() {
        timestamp = 0
        index = 0
        bookmarks = []
        history = []
        cards = [.report,
                 .activity,
                 .bookmarks,
                 .history]
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        index = .init(data.number() as UInt16)
        bookmarks = data.collection(UInt16.self)
        history = data.collection(UInt16.self)
        cards = (0 ..< .init(data.number() as UInt8))
            .map { _ in
                .init(rawValue: data.number())!
            }
        settings = .init(data: &data)
    }
}
