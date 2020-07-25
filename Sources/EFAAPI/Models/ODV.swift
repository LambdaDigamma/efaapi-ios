//
//  ODV.swift
//  
//
//  Created by Lennart Fischer on 25.07.20.
//

import Foundation
import XMLCoder

/**
 ODV is an abbreviation for "origin destination via" and is used to verify points using the EFAs location server.
 */
public struct ODV: Codable, DynamicNodeDecoding {
    
    public var type: String
    public var usage: ODVUsageType
    public var objectFilter: ObjectFilter
    public var place: ODVPlace
    
    public enum CodingKeys: String, CodingKey {
        case type
        case usage
        case objectFilter = "anyObjFilter"
        case place = "itdOdvPlace"
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.type:
                return .attribute
            case CodingKeys.usage:
                return .attribute
            case CodingKeys.objectFilter:
                return .attribute
            default:
                return .element
        }
    }
    
}
