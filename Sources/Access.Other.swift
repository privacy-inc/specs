import Foundation

extension Access {
    public struct Other: AccessType {
        public let key: Access
        public let value: String
        
        init(key: Access, value: String) {
            self.key = key
            self.value = value
        }
        
        public var url: URL? {
            .init(string: value)
        }
        
        public var content: Data {
            .init()
            .adding(size: UInt16.self, string: value)
        }
    }
}
