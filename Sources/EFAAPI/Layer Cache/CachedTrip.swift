//
//  CachedTrip.swift
//  
//
//  Created by Lennart Fischer on 18.12.22.
//

import Foundation

public struct CachedEFATrip: Codable {
    
    public var tripDate: CachedTripDate
    public var origin: CachedEFAStation
    public var via: CachedEFAStation?
    public var destination: CachedEFAStation
    
    public var lines: [CachedPartialLine] = []
    
    public init(
        tripDate: CachedTripDate,
        origin: CachedEFAStation,
        via: CachedEFAStation? = nil,
        destination: CachedEFAStation,
        lines: [CachedPartialLine] = []
    ) {
        self.tripDate = tripDate
        self.origin = origin
        self.via = via
        self.destination = destination
        self.lines = lines
    }
    
}
