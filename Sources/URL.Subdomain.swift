import Foundation
import Domains

extension URL {
    enum Subdomain: String {
        case
        sourcepoint,
        sourcepointcmp
        
        static func validation(domain: Domain) -> Policy.Validation? {
            domain
                .prefix
                .last
                .flatMap { prefix in
                    Self(rawValue: prefix)
                        .map { _ in
                                .block(tracker: prefix + "." + domain.minimal)
                        }
                }
        }
    }
}
