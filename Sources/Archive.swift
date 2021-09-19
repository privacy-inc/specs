import Foundation
import Archivable

public struct Archive: Arch {
    public static let version = UInt8()
    public static let new = Self()
    
    public var timestamp: UInt32
    
    public var data: Data {
        get async {
            .init()
        }
    }
    
    private init() {
        timestamp = 0
    }
    
    public init(version: UInt8, timestamp: UInt32, data: Data) async {
        self.timestamp = timestamp
    }
}
