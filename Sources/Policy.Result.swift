import Foundation
import Domains

extension Policy {
    public enum Result {
        case
        external,
        ignore,
        allow,
        block
    }
}
