//
//  StaticTransitService.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import Foundation
import ModernNetworking
import Combine

public class StaticTransitService: TransitService {
    
    public var loadStations: () -> ([TransitLocation])
    
    public init() {
        self.loadStations = {
            return []
        }
    }
    
    public func findTransitLocation(for searchTerm: String, filtering objectFilter: ObjectFilter) -> AnyPublisher<[TransitLocation], HTTPError> {
    
        return Just(loadStations())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
        
    }
    
}
