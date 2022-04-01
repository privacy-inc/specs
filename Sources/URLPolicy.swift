import Foundation
import Domains

protocol URLPolicy {
    static func response(for domain: Domain, on: URL) -> Policy.Response?
}
