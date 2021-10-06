import Foundation

extension Events {
    public struct Report: Identifiable {
        public let id: String
        public let date: Date
        public let website: String
        public let trackers: [String]
        
        init(date: Date, website: String, trackers: [String]) {
            self.date = date
            self.website = website
            self.trackers = trackers
            id = date.description + website
        }
    }
}
