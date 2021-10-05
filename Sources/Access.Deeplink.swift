import Foundation

extension Access {
    public struct Deeplink: AccessURL {
        public var scheme: String {
            value
                .components(separatedBy: "://")
                .first ?? ""
        }
        
        public let key = Access.deeplink
        public let value: String
        
        init(value: String) {
            self.value = value
        }
    }
}
