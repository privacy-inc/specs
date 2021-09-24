import Foundation

extension Access {
    public struct Deeplink: AccessType {
        public let key = Access.deeplink
        public let value: String
        let scheme: String
        
        init(value: String) {
            self.value = value
            scheme = value
                .components(separatedBy: "://")
                .first ?? ""
        }
    }
}
