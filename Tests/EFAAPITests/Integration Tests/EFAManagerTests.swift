import XCTest
import Combine
import ModernNetworking
@testable import EFAAPI

final class EFAManagerTests: IntegrationTestCase {
    
    func test_has_4_query_endpoints() {
        XCTAssertEqual(QueryEndpoints.allCases.count, 4)
    }
    
    func test_execute_stop_finder_request_list() {
        
        let expectation = XCTestExpectation()
        
        let httpLoader = defaultLoader()
        let manager = EFAManager(loader: httpLoader)
        
        manager
            .sendStopFinderRequest(searchText: "König")
            .sink { (completion: Subscribers.Completion<HTTPError>) in
                
            } receiveValue: { (response: StopFinderResponse) in
                
                XCTAssertEqual(response.language.count, 2)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_execute_stop_finder_request_identified() {
        
        let expectation = XCTestExpectation()
        
        let httpLoader = defaultLoader()
        let manager = EFAManager(loader: httpLoader)
        
        manager
            .sendStopFinderRequest(searchText: "Duisburg Hbf", objectFilter: [.stops])
            .sink { (completion: Subscribers.Completion<HTTPError>) in
                
                switch (completion) {
                    case .failure(let error):
                        print(error)
                    default: break
                }
                
            } receiveValue: { (response: StopFinderResponse) in
                
                XCTAssertEqual(response.language.count, 2)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    static var allTests = [
        ("test_has_4_query_endpoints", test_has_4_query_endpoints),
        ("test_execute_stop_finder_request_list", test_execute_stop_finder_request_list),
        ("test_execute_stop_finder_request_identified", test_execute_stop_finder_request_identified)
    ]
}
