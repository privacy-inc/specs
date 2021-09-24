import Foundation

extension Access {
    public struct Deeplink {
        let scheme: String
        let value: String
        
        init(value: String) {
            self.value = value
            scheme = value
                .components(separatedBy: "://")
                .first ?? ""
        }
    }
}
