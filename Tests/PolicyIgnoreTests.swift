import XCTest
@testable import Specs

final class PolicyIgnoreTests: XCTestCase {
    private var policy: PolicyLevel!
    private let list =  [
        "about:blank",
        "about:srcdoc",
        "adsadasdddsada",
        "https:///",
        "https://dfddasadas"
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
                if case .ignore = $0.1 { } else {
                    XCTFail("\($0.1): \($0.0)")
                }
            }
    }
}
