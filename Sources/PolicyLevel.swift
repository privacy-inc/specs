import Foundation

public protocol PolicyLevel {
    var level: Policy { get }
    
    func route(host: [String], path: String?) -> Policy.Result
}

extension PolicyLevel {
    func callAsFunction(_ url: URL) -> Policy.Result {
        url
            .scheme
            .map {
                URL.Embed(rawValue: $0)
                    .map(\.policy)
                ?? URL.Scheme(rawValue: $0)
                    .map {
                        switch $0.policy {
                        case .allow:
                            return url
                                .host
                                .map {
                                    (Array($0
                                            .components(separatedBy: ".")
                                            .dropLast()),
                                     url
                                        .path
                                        .components(separatedBy: "/")
                                        .dropFirst()
                                        .first)
                                }
                                .map {
                                    !$0.0.isEmpty
                                        ? route(host: $0.0, path: $0.1)
                                        : .ignore
                                }
                            ?? .ignore
                        default:
                            return $0.policy
                        }
                    }
                ?? .external
            }
            ?? .ignore
    }
    
    func route(host: [String], path: String?) -> Policy.Result {
        .allow
    }
}
