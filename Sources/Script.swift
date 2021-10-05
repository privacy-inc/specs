import Foundation

public enum Script {
    case
    favicon,
    dark
    
    public var script: String {
        switch self {
        case .favicon:
            return Self._favicon
        case .dark:
            return Self._dark
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
