//
//  TripRequest.swift
//  
//
//  Created by Lennart Fischer on 03.04.22.
//

import Foundation
import XMLCoder

public struct TripRequest: Codable, DynamicNodeDecoding {
    
    public let requestID: Int
    public let odv: [ODV]
    public var tripDateTime: ITDTripDateTime
    public let itinerary: ITDItinerary
    public let tripOptions: ITDTripOptions
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.requestID:
                return .attribute
            case CodingKeys.odv:
                return .element
            default:
                return .element
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case requestID = "requestID"
        case odv = "itdOdv"
        case tripDateTime = "itdTripDateTime"
        case itinerary = "itdItinerary"
        case tripOptions = "itdTripOptions"
    }
    
}
