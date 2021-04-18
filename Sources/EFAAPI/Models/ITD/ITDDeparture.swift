//
//  ITDDeparture.swift
//  
//
//  Created by Lennart Fischer on 19.04.21.
//

import Foundation
import XMLCoder

public struct ITDDeparture: Codable, DynamicNodeDecoding {
    
    public let regularDateTime: ITDDateTime
    public let actualDateTime: ITDDateTime?
    public let servingLine: ITDServingLine
    
    public let stopID: Stop.ID
    public let stopName: String
    public let nameWO: String
    public let latitude: Double
    public let longitude: Double
    public let platform: Int
    public let platformName: String?
    public let plannedPlatformName: String?
    public let countdown: Int
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.stopID, CodingKeys.longitude, CodingKeys.latitude,
                 CodingKeys.platform, CodingKeys.platformName, CodingKeys.plannedPlatformName,
                 CodingKeys.stopName, CodingKeys.nameWO,
                 CodingKeys.countdown:
                return .attribute
            default:
                return .elementOrAttribute
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case servingLine = "itdServingLine"
        case regularDateTime = "itdDateTime"
        case actualDateTime = "itdRTDateTime"
        case stopID = "stopID"
        case stopName = "stopName"
        case nameWO = "nameWO"
        case longitude = "x"
        case latitude = "y"
        case platform = "platform"
        case platformName = "platformName"
        case plannedPlatformName = "plannedPlatformName"
        case countdown = "countdown"
    }
    
}
