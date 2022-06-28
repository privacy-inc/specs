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
        
        if version == Self.version {
            bookmarks = data.collection(size: UInt16.self)
            history = data.collection(size: UInt16.self)
            tracking = .init(data: &data)
            settings = .init(data: &data)
        } else {
            bookmarks = []
            history = []
            tracking = .init()
            settings = .init()
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
