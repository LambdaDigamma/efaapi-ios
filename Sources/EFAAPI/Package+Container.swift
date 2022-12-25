//
//  Package+Container.swift
//  
//
//  Created by Lennart Fischer on 25.12.22.
//

import Foundation
import Factory

public extension Container {
    
    static let transitService = Factory {
        
        let service = StaticTransitService()
        
        service.loadStations = {
            return [
                .init(name: "Musterstraße", description: "Musterstadt"),
                .init(name: "Nachtigalweg", description: "Musterstadt"),
            ]
        }
        
        return service as TransitService
    }
    
    static let tripService = Factory {
        
        let service = DefaultTripService()
        
        return service
        
    }
    
}

