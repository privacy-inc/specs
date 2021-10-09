import Foundation

extension URL {
    public enum Scheme: String {
        case
        https,
        http,
        ftp,
        gmsg
        
        var policy: Policy {
            switch self {
            case .http, .https:
                return .accept
            case .ftp:
                return .ignore
            case .gmsg:
                return .block("mobileads.google.com")
            }
        }
    }
}
