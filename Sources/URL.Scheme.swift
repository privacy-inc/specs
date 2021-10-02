import Foundation

extension URL {
    public enum Scheme: String {
        case
        https,
        http,
        ftp,
        gmsg
        
        var policy: Policy.Result {
            switch self {
            case .http, .https:
                return .allow
            case .ftp:
                return .ignore
            case .gmsg:
                return .block("mobileads.google.com")
            }
        }
    }
}
