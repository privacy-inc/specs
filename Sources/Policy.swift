import Foundation

public enum Policy {
    case
    secure,
    standard
    
    func callAsFunction(_ url: URL) -> Result {
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
    
    private func route(host: [String], path: String?) -> Result {
        switch self {
        case .secure:
            return URL
                .Allow
                .init(rawValue: host.last!)
                .map { white in
                    white
                        .subdomain
                        .map(\.rawValue)
                        .intersection(other: host
                                        .dropLast())
                        .first
                        .map { (subdomain: String) -> Result in
                            .block(subdomain + "." + white.rawValue + "." + white.tld.rawValue)
                        }
                    ?? path
                        .map { (path: String) -> Result in
                            white
                                .path
                                .map(\.rawValue)
                                .contains(path) ? .block(white.rawValue + "." + white.tld.rawValue + "/" + path) : .allow
                        }
                    ?? .allow
                }
            ?? URL
                .Deny
                .init(rawValue: host.last!)
                .map(\.rawValue)
                .map(Result.block)
            ?? host
                .dropLast()
                .compactMap(URL.Subdomain.init(rawValue:))
                .map(\.rawValue)
                .first
                .map(Result.block)
            ?? .allow
        default:
            return .allow
        }
    }
}

