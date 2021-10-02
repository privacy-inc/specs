import Foundation

extension Policy {
    public enum Result {
        case
        allow,
        ignore,
        external,
        block(String)
    }
}
