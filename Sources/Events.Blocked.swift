import Foundation
import Archivable

extension Events {
    public struct Blocked: Storable {
        let relation: UInt16
        let tracker: UInt16
        
        public var data: Data {
            .init()
            .adding(relation)
            .adding(tracker)
        }
        
        public init(data: inout Data) {
            relation = data.number()
            tracker = data.number()
        }
        
        init(relation: Int, tracker: Int) {
            self.relation = .init(relation)
            self.tracker = .init(tracker)
        }
    }
}
