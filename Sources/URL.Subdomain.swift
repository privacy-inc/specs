import Foundation
import Domains

extension URL {
    enum Subdomain: String, Responser {
        case
        sourcepoint,
        sourcepointcmp
        
        static func response(for domain: Domain, on: URL) -> Policy.Response? {
            domain
                .prefix
                .last
                .flatMap { prefix in
                    Self(rawValue: prefix)
                        .map { _ in
                                .block(prefix + "." + domain.minimal)
                        }
                }
        }
    }
}
