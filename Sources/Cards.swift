import Foundation

public enum Cards: UInt8, Identifiable {
    public var id: Self {
        self
    }
    
    case
    report,
    activity,
    bookmarks,
    history
}
