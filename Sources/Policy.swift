import Foundation
import Domains

public enum Policy: UInt8 {
    case
    secure,
    standard
    
    func callAsFunction(_ url: URL) -> Response {
        url
            .scheme
            .map {
                URL.Embed(rawValue: $0)
                    .map(\.response)
                ?? URL.Scheme(rawValue: $0)
                    .map {
                        let response = $0.response
                        guard response == .allow else { return response }
                        return route(url: url)
                    }
                ?? .external
            }
            ?? .ignore
    }
    
    private func route(url: URL) -> Response {
        switch self {
        case .secure:
            return url
                .host
                .map(Tld.domain(host:))
                .map { domain in
                    guard !domain.suffix.isEmpty else { return .ignore }
                    
                    for policy in Self.policies {
                        guard let response = policy.response(for: domain, on: url) else { continue }
                        return response
                    }
                    
                    return .allow
                }
            ?? .ignore
        case .standard:
            return .allow
        }
    }
    
    private static let policies: [any Responser.Type] = [URL.Subdomain.self,
                                                         URL.Allow.self,
                                                         URL.Deny.self,
                                                         URL.Toplevel.self]
}
