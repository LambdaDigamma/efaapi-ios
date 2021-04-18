//
//  ITDServingLine.swift
//  
//
//  Created by Lennart Fischer on 19.04.21.
//

import Foundation
import XMLCoder

public struct ITDServingLine: Codable, DynamicNodeDecoding {
    
    public let direction: String
    public let directionFrom: String?
    public let descriptionText: String
    public let code: String
    public let number: String
    public let symbol: String
    public let `operator`: ITDOperator
    public let destinationID: Int
    public let transportType: TransportType
    
    public let productID: Int
    public let stateless: String
    public let realtime: Bool // TODO: Validate whether this decoding works.
    public let valid: String?
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.operator, CodingKeys.descriptionText:
                return .element
            case CodingKeys.direction, CodingKeys.stateless,
                 CodingKeys.destinationID, CodingKeys.realtime,
                 CodingKeys.valid, CodingKeys.code, CodingKeys.number,
                 CodingKeys.symbol, CodingKeys.transportType, CodingKeys.productID, CodingKeys.directionFrom:
                return .attribute
            default:
                return .elementOrAttribute
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case descriptionText = "itdRouteDescText"
        case `operator` = "itdOperator"
        case direction = "direction"
        case directionFrom = "directionFrom"
        case stateless = "stateless"
        case destinationID = "destID"
        case realtime = "realtime"
        case valid = "valid"
        case code = "code"
        case number = "number"
        case symbol = "symbol"
        case transportType = "motType"
        case productID = "productId"
    }
    
}
