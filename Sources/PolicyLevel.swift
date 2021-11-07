import Foundation

public protocol PolicyLevel {
    var level: Policy { get }
    
    func route(url: URL) -> Policy.Validation
}

extension PolicyLevel {
    func callAsFunction(_ url: URL) -> Policy.Validation {
        url
            .scheme
            .map {
                URL.Embed(rawValue: $0)
                    .map(\.validation)
                ?? URL.Scheme(rawValue: $0)
                    .map {
                        switch $0.policy {
                        case .accept:
                            return route(url: url)
                        case .ignore:
                            return .ignore
                        case let .block(tracker):
                            return .block(tracker: tracker)
                        }
                    }
                ?? .external
            }
            ?? .ignore
    }
    
    func route(url: URL) -> Policy.Validation {
        .allow
    }
}
