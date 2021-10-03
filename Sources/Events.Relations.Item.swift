import Foundation
import Archivable

extension Events.Relations {
    public struct Item: Storable {
        let timestamp: UInt16
        let domain: UInt16
        
        public var data: Data {
            .init()
            .adding(timestamp)
            .adding(domain)
        }
        
        public init(data: inout Data) {
            timestamp = data.number()
            domain = data.number()
        }
        
        init(timestamp: Int, domain: Int) {
            self.timestamp = .init(timestamp)
            self.domain = .init(domain)
        }
    }
}
