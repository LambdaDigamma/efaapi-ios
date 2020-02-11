//
//  ITDRequest.swift
//  EFAAPI
//
//  Created by Lennart Fischer on 11.02.20.
//

import Foundation
import XMLCoder

public struct ITDRequest: Codable, Equatable, DynamicNodeDecoding {
    
    public let language: String
    public let sessionID: Int
    public let now: Date
    
    enum CodingKeys: String, CodingKey {
        case language
        case sessionID
        case now
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
        case CodingKeys.language:
            return .attribute
        case CodingKeys.sessionID:
            return .attribute
        case CodingKeys.now:
            return .attribute
        default:
            return .element
        }
    }
    
}
