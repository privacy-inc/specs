import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
    public internal(set) var history: [(index: Int, website: Website)]
    var index: Int
    
    public var data: Data {
        get async {
            .init()
            .adding(UInt16(index))
        }
    }
    
    public init() {
        timestamp = 0
        index = 0
        history = []
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        
        index = .init(data.uInt16())
        history = []
    }
}
