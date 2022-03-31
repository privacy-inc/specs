import Foundation
import Domains
import Archivable

public struct Website: Storable, Identifiable {
    public var id: String
    public let title: String
    
    public var domain: Domain {
        id
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .components(separatedBy: "/")
            .first!
            .components(separatedBy: ":")
            .first
            .map(Tld.domain(host:))!
    }
    
    public var icon: String? {
        domain
            .minimal
            .lowercased()
    }
    
    public var url: URL? {
        .init(string: id)
    }
    
    public var data: Data {
        .init()
        .adding(size: UInt16.self, string: id)
        .adding(size: UInt16.self, string: title)
    }
    
    public init(data: inout Data) {
        id = data.string(size: UInt16.self)
        title = data.string(size: UInt16.self)
    }
    
    private init(id: String, title: String) {
        self.id = id
        self.title = title
    }
    
    func with(id: String) -> Self {
        .init(id: id, title: title)
    }
    
    func with(title: String) -> Self {
        .init(id: id, title: title)
    }
    
    func matches(strings: [String]) -> Int {
        title
            .rating(components: strings)
        + id
            .rating(components: strings)
    }
}

private extension String {
    func rating(components: [String]) -> Int {
        components
            .filter(localizedCaseInsensitiveContains)
            .count
    }
}
