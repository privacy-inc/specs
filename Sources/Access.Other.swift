import Foundation

extension Access {
    struct Other: AccessType {
        let key: Access
        let value: String
        
        init(key: Access, value: String) {
            self.key = key
            self.value = value
        }
        
        var url: URL? {
            .init(string: value)
        }
        
        var content: Data {
            .init()
            .adding(size: UInt16.self, string: value)
        }
    }
}
