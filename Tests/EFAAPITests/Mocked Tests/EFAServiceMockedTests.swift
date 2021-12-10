import XCTest
import Combine
import ModernNetworking
@testable import EFAAPI

final class EFAServiceMockedTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_execute_stop_finder_request_list() {
        
        let expectation = XCTestExpectation()
        
        let loader = FileLoader(resource: "Data/StopFinder_List", fileExtension: "xml")
        let service = DefaultTransitService(loader: loader)
        
        service
            .sendRawStopFinderRequest(searchText: "König")
            .sink { (completion: Subscribers.Completion<HTTPError>) in
                
            } receiveValue: { (response: StopFinderResponse) in
                
                XCTAssertEqual(response.language.count, 2)
                XCTAssertEqual(response.stopFinderRequest.odv.name?.elements?.count, 268)
                
                let expected = ITDDateTime(
                    ttpFrom: "20211101",
                    ttpTo: "20220430",
                    date: ITDDate(
                        weekday: 6,
                        year: 2021,
                        month: 12,
                        day: 10
                    ),
                    time: ITDTime(
                        hour: 0,
                        minute: 31
                    )
                )
                
                XCTAssertEqual(response.stopFinderRequest.dateTime, expected)
                XCTAssertEqual(response.stopFinderRequest.odv.usage, ODVUsageType.sf)
                XCTAssertEqual(response.stopFinderRequest.odv.name?.input?.name, "König")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)

        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func test_execute_stop_finder_request_list_objectfilter() {

        let expectation = XCTestExpectation()

        let loader = FileLoader(resource: "Data/StopFinder_List_ObjectFilter", fileExtension: "xml")
        let service = DefaultTransitService(loader: loader)

        service
            .sendRawStopFinderRequest(searchText: "Duisburg Hbf", objectFilter: [.stops])
            .sink { (completion: Subscribers.Completion<HTTPError>) in

                switch (completion) {
                    case .failure(let error):
                        print(error)
                    default: break
                }

            } receiveValue: { (response: StopFinderResponse) in

                XCTAssertEqual(response.language.count, 2)
                XCTAssertEqual(response.stopFinderRequest.odv.objectFilter, [.stops])
                XCTAssertEqual(response.stopFinderRequest.odv.name?.elements?.count, 3)

                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10)

    }
    
    static var allTests = [
        ("test_execute_stop_finder_request_list", test_execute_stop_finder_request_list),
        ("test_execute_stop_finder_request_list_objectfilter", test_execute_stop_finder_request_list_objectfilter)
    ]
}
