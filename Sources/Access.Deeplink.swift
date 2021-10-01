import Foundation

extension Access {
    public struct Deeplink: AccessURL {
        public let key = Access.deeplink
        public let value: String
        public let scheme: String
        
        init(value: String) {
            self.value = value
            scheme = value
                .components(separatedBy: "://")
                .first ?? ""
        }
    }
}
