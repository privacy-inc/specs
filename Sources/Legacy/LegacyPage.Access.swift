import Foundation

extension LegacyPage {
    enum Access: UInt8 {
        case
        remote,
        local,
        deeplink,
        embed
    }
}
