//
//  DepartureMonitorTests.swift
//  
//
//  Created by Lennart Fischer on 18.04.21.
//

import XCTest
import Combine
@testable import EFAAPI

final class DepartureMonitorTests: XCTestCase {
    
    public var manager: EFAManager!
    
    public var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        self.manager = try? EFAManager(efaEndpoint: "https://openservice.vrr.de/vrr/", host: "openservice.vrr.de")
        super.setUp()
    }
    
    func test_departureMonitorRequest() {
        
        let expectation = XCTestExpectation()
        
        let request = manager.sendDepartureMonitorRequest(id: 20036298)
        
        request.sink { (completion: Subscribers.Completion<Error>) in
            switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail(error.localizedDescription)
            }
        } receiveValue: { (response: DepartureMonitorResponse) in
            
            print(response.departureMonitorRequest)
            
        }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5)
        
        
    }
    
}
