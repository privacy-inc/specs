import Foundation

extension Policy {
    struct Secure: PolicyLevel {
        let level = Policy.secure
        
        func route(host: [String], path: String?) -> Result {
            URL
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
        }
    }
}
