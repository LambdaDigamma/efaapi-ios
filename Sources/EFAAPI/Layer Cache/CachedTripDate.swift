//
//  CachedTripDate.swift
//  
//
//  Created by Lennart Fischer on 18.12.22.
//

import Foundation

public enum CachedTripDate: Codable {
    
    case departure(Date)
    case arrival(Date)
    
}
