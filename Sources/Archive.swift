import Foundation
import Archivable

public struct Archive: Arch {
    public var timestamp: UInt32
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
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        var data = data
        self.timestamp = timestamp
        index = .init(data.uInt16())
    }
}
