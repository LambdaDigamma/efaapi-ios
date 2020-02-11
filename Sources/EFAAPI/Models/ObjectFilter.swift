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

    public static let noFilter         = ObjectFilter(rawValue: 0 << 0)
    public static let places           = ObjectFilter(rawValue: 1 << 0)
    public static let stations         = ObjectFilter(rawValue: 1 << 1)
    public static let streets          = ObjectFilter(rawValue: 1 << 2)
    public static let addresses        = ObjectFilter(rawValue: 1 << 3)
    public static let intersections    = ObjectFilter(rawValue: 1 << 4)
    public static let pointsOfInterest = ObjectFilter(rawValue: 1 << 5)
    public static let postcode         = ObjectFilter(rawValue: 1 << 6)

}
