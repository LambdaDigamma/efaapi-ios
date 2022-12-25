//
//  CachedPartialLine.swift
//  
//
//  Created by Lennart Fischer on 18.12.22.
//

import Foundation

public typealias StatelessLineIdentifier = String

public struct CachedPartialLine: Codable, Identifiable {
    
    public let id: StatelessLineIdentifier
    
    public let origin: CachedEFAStation
    public let destination: CachedEFAStation
    
    public let plannedDeparture: Date
    public let plannedArrival: Date
    
}
