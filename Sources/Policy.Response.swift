import Foundation
import Domains

extension Policy {
    public enum Response: Equatable {
        case
        deeplink,
        ignore,
        allow,
        privacy,
        block(String)
    }
}
