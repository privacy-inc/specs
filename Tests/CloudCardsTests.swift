import XCTest
import Combine
@testable import Archivable
@testable import Specs

final class CloudCardsTests: XCTestCase {
    private var cloud: Cloud<Archive>!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        cloud = .ephemeral
        subs = []
    }
    
    func testSwitch() async {
        _ = await cloud.turn(card: .bookmarks, state: false)
        
        let model = await cloud.model
        XCTAssertFalse(model.cards.first { $0.id == .bookmarks }!.state)
    }
    
    func testMove() async {
        _ = await cloud.move(card: .bookmarks, index: 0)
        
        let model = await cloud.model
        XCTAssertEqual(.bookmarks, model.cards.first!.id)
    }
    
    func testSwitchSave() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            _ = await cloud.turn(card: .bookmarks, state: false)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testMoveSave() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            _ = await cloud.move(card: .bookmarks, index: 0)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSwitchSame() {
        let expect = expectation(description: "")
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            _ = await cloud.turn(card: .trackers, state: true)
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testMoveSame() {
        let expect = expectation(description: "")
        
        cloud
            .sink { _ in
                expect.fulfill()
            }
            .store(in: &subs)
        
        Task {
            _ = await cloud.move(card: .trackers, index: 0)
        }
        
        waitForExpectations(timeout: 1)
    }
}
