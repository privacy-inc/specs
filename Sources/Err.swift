import Foundation

public struct Err: Equatable {
    public let url: URL
    public let description: String
    
    public init(url: URL, description: String) {
        self.url = url
        self.description = description
    }
}
