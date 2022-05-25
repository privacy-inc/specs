import XCTest
@testable import Specs

final class DefaultsTests: XCTestCase {
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: Defaults.created.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.premium.rawValue)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: Defaults.created.rawValue)
        UserDefaults.standard.removeObject(forKey: Defaults.premium.rawValue)
    }
    
    func testFirstTimeRate() {
        XCTAssertNil(UserDefaults.standard.object(forKey: Defaults.created.rawValue))
        XCTAssertFalse(Defaults.rate)
        XCTAssertNotNil(UserDefaults.standard.object(forKey: Defaults.created.rawValue))
    }
    
    func testRate() {
        UserDefaults.standard.setValue(Calendar.current.date(byAdding: .day, value: -5, to: .now)!, forKey: Defaults.created.rawValue)
        XCTAssertTrue(Defaults.rate)
    }
}
