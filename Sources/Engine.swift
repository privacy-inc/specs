import Foundation
import Archivable

public enum Engine: UInt8, Storable {
    case
    ecosia,
    google
    
    public var data: Data {
        .init()
            .adding(rawValue)
    }
    
    public init(data: inout Data) {
        self.init(rawValue: data.removeFirst())!
    }
    
    func query(_ search: String) -> String? {
        var components = URLComponents(string: "//www." + url.rawValue + "." + url.tld.rawValue)!
        components.scheme = "https"
        components.path = "/search"
        components.queryItems = [.init(name: "q", value: search)]
        return components.string
    }
    
    private var url: URL.Allow {
        switch self {
        case .ecosia: return .ecosia
        case .google: return .google
        }
    }
}
