import Foundation
import Domains

extension Policy {
    public enum Response {
        case
        external,
        ignore,
        allow,
        block(String)
    }
}
