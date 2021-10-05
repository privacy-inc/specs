import Foundation

public enum Script {
    case
    favicon,
    dark,
    unpromise
    
    public var script: String {
        switch self {
        case .favicon:
            return Self._favicon
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
