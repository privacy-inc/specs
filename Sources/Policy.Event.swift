import Foundation
import Domains

extension Policy {
    enum Event {
        case
        none,
        allow(Domain),
        block(String)
    }
}
