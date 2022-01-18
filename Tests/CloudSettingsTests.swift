import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudSettingsTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .init()
        subs = []
    }
    
    func testSearch() {
        mutate {
            await self.cloud.update(search: .ecosia)
        }
    }
    
    func testPolicy() {
        mutate {
            await self.cloud.update(policy: .standard)
        }
    }
    
    func testAutoplay() {
        mutate {
            await self.cloud.update(autoplay: .all)
        }
    }
    
    func testJavascript() {
        mutate {
            await self.cloud.update(javascript: false)
        }
    }
    
    func testPopups() {
        mutate {
            await self.cloud.update(popups: true)
        }
    }
    
    func testLocation() {
        mutate {
            await self.cloud.update(location: true)
        }
    }
    
    func testTimers() {
        mutate {
            await self.cloud.update(timers: false)
        }
    }
    
    func testDark() {
        mutate {
            await self.cloud.update(dark: false)
        }
    }
    
    func testAds() {
        mutate {
            await self.cloud.update(ads: true)
        }
    }
    
    func testScreen() {
        mutate {
            await self.cloud.update(screen: true)
        }
    }
    
    func testCookies() {
        mutate {
            await self.cloud.update(cookies: true)
        }
    }
    
    func testHttp() {
        mutate {
            await self.cloud.update(http: true)
        }
    }
    
    func testThird() {
        mutate {
            await self.cloud.update(third: false)
        }
    }
    
    private func mutate(operation: @escaping @Sendable () async -> Void) {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task(operation: operation)
        
        waitForExpectations(timeout: 1)
    }
}
