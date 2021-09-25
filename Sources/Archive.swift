import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var history: [History]
    public internal(set) var settings: Settings
    var index: Int
    
    public var data: Data {
        .init()
        .adding(UInt16(index))
        .adding(UInt16(history.count))
        .adding(history.flatMap(\.data))
        .adding(settings.data)
    }
    
    public init() {
        timestamp = 0
        index = 0
        history = []
        settings = .init()
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        index = .init(data.uInt16())
        history = (0 ..< .init(data.uInt16()))
            .map { _ in
                .init(data: &data)
            }
        settings = .init(data: &data)
    }
}
