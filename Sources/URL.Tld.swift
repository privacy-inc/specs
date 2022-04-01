import Foundation
import Domains

extension URL {
    enum Toplevel: String, URLPolicy {
        case
        cloudfront,
        googleapis
        
        static func response(for domain: Domain, on: URL) -> Policy.Response? {
            Self(rawValue: domain.suffix.first!)
                .map { _ in
                    .block(domain.minimal)
                }
        }
    }
}
