import Foundation
import Domains

extension Policy {
    public enum Response: Equatable {
        case
        external,
        ignore,
        allow,
        block(String)
    }
}
