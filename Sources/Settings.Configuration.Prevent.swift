import Foundation

extension Settings.Configuration {
    public enum Prevent: UInt8 {
        case
        none,
        audio,
        video,
        all
    }
}
