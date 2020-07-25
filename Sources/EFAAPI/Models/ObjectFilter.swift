//
//  ObjectFilter.swift
//  EFAAPI
//
//  Created by Lennart Fischer on 10.02.20.
//

import Foundation

public struct ObjectFilter: OptionSet {

    public init(rawValue: Self.RawValue) {
        self.rawValue = rawValue
    }
    
    public let rawValue: Int

    /**
     No filter active. Search the entire search space.
     */
    public static let noFilter         = ObjectFilter(rawValue: 0 << 0)
    
    /**
     Search in all places of the covered GIS area.
     */
    public static let places           = ObjectFilter(rawValue: 1 << 0)
    
    /**
     Search within all stop IDs and alias names for stops recorded in the covered GIS area.
     */
    public static let stops            = ObjectFilter(rawValue: 1 << 1)
    
    /**
     Search within all street names defined in the covered GIS area.
     */
    public static let streets          = ObjectFilter(rawValue: 1 << 2)
    
    /**
     Search within all addresses defined in the covered GIS area.
     */
    public static let addresses        = ObjectFilter(rawValue: 1 << 3)
    
    /**
     Search within all crossings recorded in the covered GIS area.
     */
    public static let crossing         = ObjectFilter(rawValue: 1 << 4)
    
    /**
     Search within all IDs and alias names of important points defined in the covered GIS area.
     */
    public static let pointsOfInterest = ObjectFilter(rawValue: 1 << 5)
    
    /**
     Search within all postal codes covered by the GIS.
     */
    public static let postcode         = ObjectFilter(rawValue: 1 << 6)

}
