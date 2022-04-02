import Foundation
import Domains

extension String {
    func rating(components: [String]) -> Int {
        components
            .filter(localizedCaseInsensitiveContains)
            .count
    }
}
