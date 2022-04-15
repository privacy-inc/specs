import Foundation

extension URL {
    enum Embed: String {
        case
        about,
        data,
        file,
        blob
        
        var response: Policy.Response {
            switch self {
            case .about, .blob:
                return .ignore
            case .data, .file:
                return .allow
            }
        }
    }
}
