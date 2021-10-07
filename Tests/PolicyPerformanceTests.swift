import XCTest
@testable import Specs

final class PolicyPerformanceTests: XCTestCase {
    func test() {
        let policy = Policy.Secure()
        
        let urls = urls
            .map {
                URL(string: $0)!
            }
        
        measure {
            urls
                .forEach {
                    _ = policy($0)
                }
        }
    }
}
