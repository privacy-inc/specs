import Foundation

extension Events {
    public struct Stats {
        public let timeline: [Double]
        public let websites: Int
        public let domains: (top: String, count: Int)?
        public let trackers: (top: String, count: Int)?
    }
}
