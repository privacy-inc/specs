import Foundation

public enum Script {
    case
    favicon,
    content,
    dark,
    unpromise
    
    public var script: String {
        switch self {
        case .favicon:
            return Self._favicon
        case .content:
            return Self._content
        case .dark:
            return Self._dark
        case .unpromise:
            return Self._unpromise
        }
    }
    
    public var method: String {
        switch self {
        case .favicon:
            return "GoPrivacyApp_favicon()"
        default:
            return ""
        }
    }
}
