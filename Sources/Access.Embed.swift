import Foundation

extension Access {
    public struct Embed: AccessType {
        public let key = Access.embed
        public let value: String
        public let prefix: String
        
        init(value: String) {
            self.value = value
            prefix = value
                .components(separatedBy: ";")
                .first ?? ""
        }
    }
}
