import XCTest
@testable import EFAAPI

final class EFAManagerTests: XCTestCase {
    
    public var manager: EFAManager!
    
    override func setUp() {
        self.manager = EFAManager(efaEndpoint: "https://openservice.vrr.de/vrr/XML_DM_REQUEST")
        super.setUp()
    }
    
    func testSetup() {
        XCTAssertEqual(manager.endpoint, "https://openservice.vrr.de/vrr/XML_DM_REQUEST")
    }

    static var allTests = [
        ("testSetup", testSetup),
    ]
}
