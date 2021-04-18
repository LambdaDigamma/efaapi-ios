//
//  ObjectFilter.swift
//  EFAAPI
//
//  Created by Lennart Fischer on 10.02.20.
//

import Foundation

public struct ObjectFilter: OptionSet {

    public typealias RawValue = Int
    public let rawValue: RawValue
    
    public init(rawValue: Self.RawValue) {
        self.rawValue = rawValue
    }
    
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

    public static func displayName(_ objectFilter: ObjectFilter, includeNoFilterCase: Bool = false) -> String {
        var list: [String] = []
        
        if objectFilter.contains(.noFilter) && includeNoFilterCase {
            list.append("Kein Filter")
        }
        if objectFilter.contains(.places) {
            list.append("Ort")
        }
        if objectFilter.contains(.stops) {
            list.append("Haltestelle")
        }
        if objectFilter.contains(.streets) {
            list.append("Straße")
        }
        if objectFilter.contains(.addresses) {
            list.append("Adresse")
        }
        if objectFilter.contains(.crossing) {
            list.append("Kreuzung")
        }
        if objectFilter.contains(.pointsOfInterest) {
            list.append("Interessanter Ort")
        }
        if objectFilter.contains(.postcode) {
            list.append("Postleitzahl")
        }
        
        return ListFormatter().string(from: list) ?? "nicht bekannt"
    }
    
}

extension ObjectFilter: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        
        self = ObjectFilter(rawValue: rawValue)
        
    }
    
}

extension ObjectFilter: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
        
    }
    
}
