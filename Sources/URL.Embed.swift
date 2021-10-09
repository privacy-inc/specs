import Foundation

extension URL {
    enum Embed: String {
        case
        about,
        data,
        file
        
        var validation: Policy.Validation {
            switch self {
            case .about:
                return .ignore
            case .data, .file:
                return .allow
            }
        }
    }
}
