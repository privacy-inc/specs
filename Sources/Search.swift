import Foundation
import Archivable
import Domains

public struct Search: Storable {
    public let engine: Engine
    private let components: URLComponents
    
    public var data: Data {
        .init([engine.rawValue])
    }
    
    public init(data: inout Data) {
        self.init(engine: .init(rawValue: data.removeFirst())!)
    }
    
    init(engine: Engine) {
        self.engine = engine
        components = engine.components
    }
    
    func callAsFunction(_ search: String) -> String? {
        search
            .trimmed {
                $0.url
                    ?? $0.file
                    ?? $0.partial
                    ?? query(search: $0)
            }
    }
    
    private func query(search: String) -> String? {
        var components = components
        components.queryItems = [.init(name: "q", value: search)]
        return components.string
    }
}

private extension String {
    func trimmed(transform: (Self) -> Self?) -> Self? {
        {
            $0.isEmpty ? nil : transform($0)
        } (trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var url: Self? {
        (.init(string: self)
            ?? addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed.union(.urlFragmentAllowed))
            .flatMap(URL.init(string:)))
                .flatMap {
                    $0.scheme != nil && ($0.host != nil || $0.query != nil)
                        ? ($0.scheme?.contains("http") == true ? $0.absoluteString.urlCased : $0.absoluteString)
                        : nil
                }
    }
    
    var file: Self? {
        {
            $0
                .flatMap {
                    $0.isFileURL ? self : nil
                }
        } (URL(string: self))
    }
    
    var partial: Self? {
        {
            $0.count > 1
                && $0
                    .last
                    .flatMap {
                        Tld.suffix[$0.lowercased()]
                    } != nil
                && !$0.first!.isEmpty
                && !contains(" ")
                ? URL.Scheme.https.rawValue + "://" + lowercased()
                : nil
        } (components(separatedBy: "/")
            .first!
            .components(separatedBy: "."))
    }
    
    var urlCased: Self {
        {
            ($0.count > 1 ? $0.first! + "://" : "") + {
                $0.first!.lowercased() + ($0.count > 1 ? "/" + $0.dropFirst().joined(separator: "/") : "")
            } ($0.last!.components(separatedBy: "/"))
        } (components(separatedBy: "://"))
    }
}
