import Foundation

extension Search {
    public enum Engine: UInt8 {
        case
        google,
        ecosia
        
        var components: URLComponents {
            {
                var components = URLComponents(string: "//www." + $0.rawValue + "." + $0.tld.rawValue)!
                components.scheme = "https"
                components.path = "/search"
                return components
            } (url)
        }
        
        private var url: URL.Allow {
            switch self {
            case .google: return .google
            case .ecosia: return .ecosia
            }
        }
    }
}
