//
//  ODVNameElement.swift
//  
//
//  Created by Lennart Fischer on 25.07.20.
//

import Foundation
import XMLCoder

public struct ODVNameElement: Codable, DynamicNodeDecoding {
    
    public var id: Int?
    public var listIndex: Int?
    public var mapItemList: ITDMapItemList?
    public var name: String
    public var matchQuality: Int
    public var lat: Double?
    public var lng: Double?
    public var mapName: String?
    
    
    /**
     District code number of the element. Also known as 'Gemeindekennziffer' (GKZ or OMC).
     */
    public var omc: Int?
    
    public var placeID: Int?
    public var type: ObjectFilter?
    public var anyType: String?
    public var locality: String?
    public var objectName: String?
    public var buildingName: String?
    public var buildingNumber: String?
    public var postcode: String?
    public var streetName: String?
    public var nameKey: String?
    public var mainLocality: String?
    public var stateless: String
    public var value: String?
    
    
    // Can be found in DM requests
    public var stopID: Stop.ID?
    public var isTransferStop: Bool?
    public var tariffArea: String?
    public var tariffAreaName: String?
    public var tariffLayer1: String?
    public var tariffLayer2: String?
    
    public enum CodingKeys: String, CodingKey {
        case listIndex
        case mapItemList = "itdMapItemList"
        case name = ""
        case locality
        case matchQuality
        case lng = "x"
        case lat = "y"
        case mapName
        case id
        case omc
        case placeID
        case type = "anyTypeSort"
        case anyType
        case objectName
        case buildingName
        case buildingNumber
        case postcode = "postCode"
        case streetName
        case nameKey
        case mainLocality
        case stateless
        case value
        
        case stopID = "stopID"
        case isTransferStop
        case tariffArea
        case tariffAreaName
        case tariffLayer1
        case tariffLayer2
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.mapItemList:
                return .element
            case CodingKeys.name:
                return .elementOrAttribute
            default:
                return .attribute
        }
    }
    
}
