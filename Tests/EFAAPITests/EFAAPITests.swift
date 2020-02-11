import XCTest
@testable import EFAAPI

final class EFAManagerTests: XCTestCase {
    
    public var manager: EFAManager!
    
    override func setUp() {
        self.manager = try? EFAManager(efaEndpoint: "https://openservice.vrr.de/vrr/")
        super.setUp()
    }
    
    func test_setup() {
        XCTAssertEqual(manager.endpoint, "https://openservice.vrr.de/vrr/")
    }
    
    func test_has_4_query_endpoints() {
        XCTAssertEqual(EFAManager.QueryEndpoints.allCases.count, 4)
    }
    
    func test_object_filter() {
        
        let stationsAndPOIsFilter: ObjectFilter = [.stations, .pointsOfInterest]
        XCTAssertEqual(stationsAndPOIsFilter.rawValue, 34)
        
        let placesAndStreetsFilter: ObjectFilter = [.places, .streets]
        XCTAssertEqual(placesAndStreetsFilter.rawValue, 5)
        
        let intersectionsAndAddressesAndPostcodesFilter: ObjectFilter =
            [.intersections, .addresses, .postcode]
        XCTAssertEqual(intersectionsAndAddressesAndPostcodesFilter.rawValue, 88)
        
        let fullSearchFilter: ObjectFilter = [.noFilter]
        XCTAssertEqual(fullSearchFilter.rawValue, 0)
        
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
    
    static var allTests = [
        ("test_setup", test_setup),
        ("test_has_4_query_endpoints", test_has_4_query_endpoints),
        ("test_object_filter", test_object_filter)
    ]
}
