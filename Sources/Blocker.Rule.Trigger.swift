import Foundation

extension Blocker.Rule {
    enum Trigger: Equatable {
        case
        all,
        script,
        url(URL.Allow)
    }
}
