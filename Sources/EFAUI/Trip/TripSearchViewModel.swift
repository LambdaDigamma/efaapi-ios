//
//  TripSearchViewModel.swift
//  
//
//  Created by Lennart Fischer on 05.04.22.
//

import Foundation
import EFAAPI
import ModernNetworking
import Combine

public class TripSearchViewModel: ObservableObject {
    
    @Published var originID: Stop.ID?
    @Published var destinationID: Stop.ID?
    
    @Published var origin: TransitLocation?
    @Published var destination: TransitLocation?
    
    @Published var result: DataState<TripRequest, Error> = .empty
    
    public var onSearchEvent: (() -> Void)?
    
    private let transitService: DefaultTransitService
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        transitService: DefaultTransitService,
        originID: Stop.ID? = nil,
        destinationID: Stop.ID? = nil
    ) {
        self.transitService = transitService
        self.originID = originID
        self.destinationID = destinationID
    }
    
    public func updateOrigin(_ origin: TransitLocation) {
        self.originID = origin.stationID
        self.origin = origin
    }
    
    public func updateDestination(_ destination: TransitLocation) {
        self.destinationID = destination.stationID
        self.destination = destination
    }
    
    public func search() {
        
        guard let originID = originID, let destinationID = destinationID else {
            return
        }
        
        transitService.sendTripRequest(origin: originID, destination: destinationID)
            .sink { (completion: Subscribers.Completion<HTTPError>) in
                
                switch completion {
                    case .failure(let error):
                        
                        print(error.underlyingError)
                        
                        self.result = .error(error)
                    default: break
                }
                
            } receiveValue: { (response: TripResponse) in
                
                self.result = .success(response.tripRequest)
                
            }
            .store(in: &cancellables)
        
    }
    
}
