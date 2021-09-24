import XCTest
@testable import Specs

final class DeeplinkTests: XCTestCase {
    func testScheme() {
        XCTAssertEqual("itms-services", Access.Deeplink(value: "itms-services://?action=purchaseIntent&bundleId=incognit&productIdentifier=incognit.plus").scheme)
    }
}
