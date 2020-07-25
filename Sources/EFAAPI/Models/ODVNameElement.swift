//
//  ODVNameElement.swift
//  
//
//  Created by Lennart Fischer on 25.07.20.
//

import Foundation
import XMLCoder

public struct ODVNameElement: Codable, DynamicNodeDecoding {
    
    public var id: Int
    public var listIndex: Int?
    public var name: String
    public var matchQuality: Int
    public var x: Int
    public var y: Int
    public var mapName: String
    public var omc: Int
    public var placeID: Int
    public var type: ObjectFilter
    public var anyType: String
    public var locality: String
    public var objectName: String
    public var buildingName: String
    public var buildingNumber: String
    public var postcode: String
    public var streetName: String
    public var nameKey: String
    public var mainLocality: String
    public var stateless: String
    public var value: String
    
    public enum CodingKeys: String, CodingKey {
        case listIndex
        case name = ""
        case locality
        case matchQuality
        case x
        case y
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
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.name:
                return .element
            default:
                return .attribute
        }
    }
    
}
