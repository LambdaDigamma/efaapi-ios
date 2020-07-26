import XCTest
@testable import EFAAPI

final class EFAManagerTests: XCTestCase {
    
    public var manager: EFAManager!
    
    override func setUp() {
        self.manager = try? EFAManager(efaEndpoint: "https://openservice.vrr.de/vrr/", host: "openservice.vrr.de")
        super.setUp()
    }
    
    func test_setup() {
        XCTAssertEqual(manager.endpoint, "https://openservice.vrr.de/vrr/")
    }
    
    func test_has_4_query_endpoints() {
        XCTAssertEqual(EFAManager.QueryEndpoints.allCases.count, 4)
    }
    
    func test_execute_request() {
        
        let expectation = XCTestExpectation()
        
        manager.executeRequest { request in
            
            print(request)
            
            XCTAssertEqual(request.language.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_execute_stop_finder_request_list() {
        
        let expectation = XCTestExpectation()
        
        manager.sendStopFinderRequest(searchText: "König") { request in
            print(request.stopFinderRequest)
            XCTAssertEqual(request.language.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_execute_stop_finder_request_identified() {
        
        let expectation = XCTestExpectation()
        
        manager.sendStopFinderRequest(searchText: "Königlicher Hof") { request in
            print(request.stopFinderRequest)
            XCTAssertEqual(request.language.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    static var allTests = [
        ("test_setup", test_setup),
        ("test_has_4_query_endpoints", test_has_4_query_endpoints),
        ("test_execute_request", test_has_4_query_endpoints),
        ("test_execute_stop_finder_request_list", test_execute_stop_finder_request_list),
        ("test_execute_stop_finder_request_identified", test_execute_stop_finder_request_identified)
    ]
}
