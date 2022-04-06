//
//  ITDRoute.swift
//  
//
//  Created by Lennart Fischer on 04.04.22.
//

import Foundation
import XMLCoder

public struct ITDRoute: Codable, DynamicNodeDecoding, Identifiable {
    
    public let idx: Int
    public let active: Int
    public let selected: Int
    public let numberOfChanges: Int
    public let distance: Int
    public let routeIndex: Int
    public let searchMode: Int
    public let cTime: Int
    public let vehicleTime: Int
    public let publicDuration: String

    public let partialRouteList: ITDPartialRouteList
    public let fare: ITDFare
    public let infoTextList: ITDInfoTextList
    
    public var id: Int {
        return idx
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.active,
                CodingKeys.idx,
                CodingKeys.selected,
                CodingKeys.numberOfChanges,
                CodingKeys.distance,
                CodingKeys.routeIndex,
                CodingKeys.searchMode,
                CodingKeys.cTime,
                CodingKeys.vehicleTime,
                CodingKeys.publicDuration
                :
                return .attribute
            default:
                return .element
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case idx = "idx"
        case active = "active"
        case selected = "selected"
        case numberOfChanges = "changes"
        case distance = "distance"
        case routeIndex = "routeIndex"
        case searchMode = "searchMode"
        case cTime = "cTime"
        case vehicleTime = "vehicleTime"
        case publicDuration = "publicDuration"

        case partialRouteList = "itdPartialRouteList"
        case fare = "itdFare"
        case infoTextList = "itdInfoTextList"
    }
    
}
