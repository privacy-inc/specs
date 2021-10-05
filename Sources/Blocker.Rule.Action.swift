import Foundation

extension Blocker.Rule {
    enum Action {
        case
        cookies,
        http,
        block,
        css(Set<String>)
    }
}
