//
//  ITDPoint.swift
//  
//
//  Created by Lennart Fischer on 04.04.22.
//

import Foundation
import XMLCoder

public struct ITDPoint: Codable, Equatable, Hashable, DynamicNodeDecoding {
    
    public let stopID: Int
    public let usage: Usage
    public let area: String
    public let platform: String
    public let gid: String
    public let areaGid: String
    public let name: String
    public let nameWO: String
    public let place: String
    public let platformName: String
    public let plannedPlatformName: String
    public let pointType: String?
    public let x: Double
    public let y: Double
    public let mapName: String
    public let niveau: Int
    public let omc: Int
    public let placeID: Int
    public let locality: String
    public let georef: String?
    
    public let dateTime: ITDDateTime
    public let targetDateTime: ITDDateTime
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.dateTime, CodingKeys.targetDateTime:
                return .element
            default:
                return .attribute
        }
    }
    
    public enum Usage: String, Codable, Hashable {
        case departure = "departure"
        case arrival = "arrival"
        case via = "via"
    }
    
    public enum CodingKeys: String, CodingKey {
        case stopID = "stopID"
        case usage = "usage"
        case area
        case platform
        case gid
        case areaGid
        case name
        case nameWO
        case place
        case platformName
        case plannedPlatformName
        case pointType
        case x
        case y
        case mapName
        case niveau
        case omc
        case placeID
        case locality
        case georef
        
        case dateTime = "itdDateTime"
        case targetDateTime = "itdDateTimeTarget"
    }
    
}

