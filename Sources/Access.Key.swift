import Foundation

extension Access {
    enum Key: UInt8 {
        case
        remote,
        local,
        deeplink,
        embed
    }
    
    var key: Key {
        switch self {
        case .remote: return .remote
        case .local: return .local
        case .deeplink: return .deeplink
        case .embed: return .embed
        }
    }
}
