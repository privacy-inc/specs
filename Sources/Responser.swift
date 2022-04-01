import Foundation
import Domains

protocol Responser {
    static func response(for domain: Domain, on: URL) -> Policy.Response?
}
