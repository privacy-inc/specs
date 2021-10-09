import XCTest
@testable import Specs

final class PolicyExternalTests: XCTestCase {
    private var policy: PolicyLevel!
    private let list = [
        "some://www.ecosia.org",
        "apps://www.theguardian.com/email/form/footer/today-uk",
        "sms://uk.reuters.com/",
        "dsddasdsa://"
    ]

    override func setUp() {
        policy = Policy.Secure()
    }
    
    func test() {
        list
            .map {
                ($0, policy(URL(string: $0)!))
            }
            .forEach {
                if case .external = $0.1.result { } else {
                    XCTFail("\($0.1): \($0.0)")
                }
            }
    }
}
