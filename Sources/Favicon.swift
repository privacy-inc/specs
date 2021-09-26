import Foundation
import Combine

public final class Favicon {
    public let icons = CurrentValueSubject<[String : Data], Never>([:])
    var requested = Set<String>()
    private var subs = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "", qos: .utility)
    
    /*
     
     let (location, response) = try await urlsession.shared.download(from: url)
     guard let httpResponse = response as? httpresonse,
     httpResponse.statusCode == 200,
     
     
     Filemanager.default.moveItem(at: location, to: newLocation)
     .// delete item at location
     
     
     */
    
    
    private lazy var path: URL = {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("icons")
        
        if !FileManager.default.fileExists(atPath: url.path) {
            var resources = URLResourceValues()
            resources.isExcludedFromBackup = true
            try? url.setResourceValues(resources)
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        return url
    } ()
    
    public init() {
        
    }
    
    public func needs(domain: String) -> Bool {
        !requested.contains(domain)
    }
    
    public func load(domain: String) {
        guard icons.value[domain] == nil else { return }
        
        queue
            .async {
                let url = self.path.appendingPathComponent(domain)
                if FileManager.default.fileExists(atPath: url.path) {
                    (try? Data(contentsOf: url))
                        .map { data in
                            DispatchQueue
                                .main
                                .async {
                                    self.icons.value[domain] = data
                                }
                        }
                }
            }
    }
    
    public func save(domain: String, url: String) {
        guard
            !domain.isEmpty,
            !url.isEmpty,
            !requested.contains(domain) || icons.value[domain] == nil
        else { return }
        
        requested.insert(domain)
        load(domain: domain)
        
        URL(string: url)
            .map {
                URLSession
                    .shared
                    .dataTaskPublisher(for: $0)
                    .map(\.data)
                    .receive(on: queue)
                    .replaceError(with: .init())
                    .filter {
                        !$0.isEmpty
                    }
                    .sink {
                        self.save(domain: domain, data: $0)
                    }
                    .store(in: &subs)
            }
    }
    
    public func clear() {
        queue
            .async {
                try? FileManager.default.removeItem(at: self.path)
                DispatchQueue
                    .main
                    .async {
                        self.requested = []
                        self.icons.value = [:]
                    }
            }
    }
    
    func save(domain: String, data: Data) {
        try? data.write(to: path.appendingPathComponent(domain), options: .atomic)
        DispatchQueue
            .main
            .async {
                self.icons.value[domain] = data
            }
    }
}
