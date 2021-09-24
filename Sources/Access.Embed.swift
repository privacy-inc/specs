import Foundation

extension Access {
    public struct Embed {
        public let prefix: String
        public let value: String
        
        init(value: String) {
            self.value = value
            prefix = value
                .components(separatedBy: ";")
                .first ?? ""
        }
    }
}
