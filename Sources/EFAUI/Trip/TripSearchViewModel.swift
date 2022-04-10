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
import OSLog

public class TripSearchViewModel: ObservableObject {
    
    @Published public var originID: StatelessIdentifier?
    @Published public var destinationID: StatelessIdentifier?
    
    @Published public var origin: TransitLocation?
    @Published public var destination: TransitLocation?
    
    @Published var result: DataState<TripRequest, Error> = .empty
    
    public var onSearchEvent: (() -> Void)?
    
    private let transitService: DefaultTransitService
    private var cancellables = Set<AnyCancellable>()
    private let logger: Logger = .init(.default)
    
    public init(
        transitService: DefaultTransitService,
        originID: StatelessIdentifier? = nil,
        destinationID: StatelessIdentifier? = nil
    ) {
        self.transitService = transitService
        self.originID = originID
        self.destinationID = destinationID
    }
    
    public func updateOrigin(_ origin: TransitLocation) {
        self.originID = origin.statelessIdentifier
        self.origin = origin
        if let originID = originID {
            self.logger.info("User updated origin to station: \(originID)")
        }
    }
    
    public func updateDestination(_ destination: TransitLocation) {
        self.destinationID = destination.statelessIdentifier
        self.destination = destination
        if let destinationID = destinationID {
            self.logger.info("User updated destination to station: \(destinationID)")
        }
    }
    
    public func search() {
        
        guard let originID = originID, let destinationID = destinationID else {
            return
        }
        
        self.result = .loading
        
        transitService.sendTripRequest(origin: originID, destination: destinationID)
            .sink { (completion: Subscribers.Completion<HTTPError>) in
                
                switch completion {
                    case .failure(let error):
                        
                        print(error.underlyingError ?? "")
                        
                        self.result = .error(error)
                    default: break
                }
                
            } receiveValue: { [weak self] (response: TripResponse) in
                
                if self?.origin == nil, let nameElement = response.tripRequest.odv.origin?.name?.elements?.first {
                    self?.origin = .init(odvNameElement: nameElement)
                }
                
                if self?.destination == nil, let nameElement = response.tripRequest.odv.destination?.name?.elements?.first {
                    self?.destination = .init(odvNameElement: nameElement)
                }
                
                self?.result = .success(response.tripRequest)
                
            }
            .store(in: &cancellables)
        
    }
    
}
