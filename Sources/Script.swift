import Foundation

public enum Script {
    case
    favicon,
    dark,
    unpromise,
    find,
    text
    
    public var script: String {
        switch self {
        case .favicon:
            return Self._favicon
        case .dark:
            return Self._dark
        case .unpromise:
            return Self._unpromise
        case .find:
            return Self._find
        case .text:
            return Self._text
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
