import Foundation

public enum Script {
    case
    favicon
    
    public var script: String {
        switch self {
        case .favicon:
            return Self._favicon
        }
    }
    
    public var method: String {
        switch self {
        case .favicon:
            return "GoPrivacyApp_favicon()"
        }
    }
}
