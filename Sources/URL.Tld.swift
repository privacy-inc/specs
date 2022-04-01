import Foundation
import Domains

extension URL {
    enum Toplevel: String, Responser {
        case
        cloudfront,
        googleapis
        
        static func response(for domain: Domain, on: URL) -> Policy.Response? {
            Self(rawValue: domain.suffix.first!)
                .map {
                    .block($0.rawValue)
                }
        }
    }
}
