//
//  ODVUsageType.swift
//  
//
//  Created by Lennart Fischer on 25.07.20.
//

import Foundation
import XMLCoder

public enum ODVUsageType: String, Codable {
    
    case origin
    case destination
    case via
    case dm
    case sf
    
}
