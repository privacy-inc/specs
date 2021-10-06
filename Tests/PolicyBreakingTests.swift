import XCTest
@testable import Specs

final class PolicyBreakingTests: XCTestCase {
    private var policy: PolicyLevel!
    private let list =  [
        "https://consent.youtube.com/m?continue=https%3A%2F%2Fwww.youtube.com%2F&gl=DE&m=0&pc=yt&uxe=23983172&hl=en-GB&src=1",
        "https://consent.google.com/?hl=en&origin=https://www.google.com&continue=https://www.google.com/search?q%3Dweather%2Bberlin&if=1&m=0&pc=s&wp=-1&gl=GR",
        "https://giphy.com/search/kitten-kiss"
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
                if case .allow = $0.1 { } else {
                    XCTFail("\($0.1): \($0.0)")
                }
            }
    }
}
