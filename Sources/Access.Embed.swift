import Foundation

extension Access {
    public struct Embed: AccessURL {
        public let key = Access.embed
        public let value: String
        
        init(value: String) {
            self.value = value
        }
    }
}
