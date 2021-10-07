import Foundation
import Domains

extension URL {
    enum Toplevel: String {
        case
        cloudfront,
        googleapis
        
        static func result(domain: Domain) -> Policy.Result? {
            Self(rawValue: domain.suffix.first!)
                .map { _ in
                    .block(domain.minimal)
                }
        }
    }
}
