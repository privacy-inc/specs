import Foundation
import Archivable

#warning("sunset")

struct Website_v0: Storable, Identifiable {
    var id: String {
        access.value
    }
    
    let title: String
    let access: any AccessType
    
    var data: Data {
        .init()
        .adding(size: UInt16.self, string: title)
        .adding(access.data)
    }
    
    init(data: inout Data) {
        title = data.string(size: UInt16.self)
        access = Access.with(data: &data)
    }
    
    init(access: any AccessType) {
        self.init(title: "", access: access)
    }
    
    init(url: URL) {
        self.init(title: "", access: Access.with(url: url))
    }
    
    private init(title: String, access: any AccessType) {
        self.title = title
        self.access = access
    }
    
    func with(title: String) -> Self {
        .init(title: title, access: access)
    }
    
    func with(access: any AccessType) -> Self {
        .init(title: title, access: access)
    }
    
    func matches(strings: [String]) -> Int {
        title
            .rating(components: strings)
        + access
            .value
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
