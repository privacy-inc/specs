import Foundation
import Domains

extension URL {
    enum Toplevel: String {
        case
        cloudfront,
        googleapis
        
        static func validation(domain: Domain) -> Policy.Validation? {
            Self(rawValue: domain.suffix.first!)
                .map { _ in
                    .block(tracker: domain.minimal)
                }
        }
    }
}
