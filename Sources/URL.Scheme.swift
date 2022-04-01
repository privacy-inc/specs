import Foundation

extension URL {
    public enum Scheme: String {
        case
        https,
        http,
        ftp,
        gmsg
        
        var response: Policy.Response {
            switch self {
            case .http, .https:
                return .allow
            case .ftp:
                return .ignore
            case .gmsg:
                return .block(Allow.Subdomain.mobileads.rawValue)
            }
        }
    }
}
