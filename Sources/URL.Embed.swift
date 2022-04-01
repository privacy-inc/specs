import Foundation

extension URL {
    enum Embed: String {
        case
        about,
        data,
        file
        
        var response: Policy.Response {
            switch self {
            case .about:
                return .ignore
            case .data, .file:
                return .allow
            }
        }
    }
}
