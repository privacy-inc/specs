import Foundation

public protocol PolicyLevel {
    var level: Policy { get }
    
    func route(url: URL) -> Policy.Result
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
                            return route(url: url)
//                            return url
//                                .host
//                                .map {
//                                    (host: Array($0
//                                            .components(separatedBy: ".")
//                                            .dropLast()),
//                                     path: url
//                                        .path
//                                        .components(separatedBy: "/")
//                                        .dropFirst()
//                                        .first)
//                                }
//                                .map {
//                                    !$0.0.isEmpty
//                                        ? route(host: $0.host, path: $0.path)
//                                        : .ignore
//                                }
//                            ?? .ignore
                        default:
                            return $0.policy
                        }
                    }
                ?? .external
            }
            ?? .ignore
    }
    
    func route(url: URL) -> Policy.Result {
        .allow
    }
}
