//
//  ITDDateTime.swift
//  
//
//  Created by Lennart Fischer on 25.07.20.
//

import Foundation
import XMLCoder

public struct ITDDateTime: Codable, DynamicNodeDecoding {
    
    public var ttpFrom: String
    public var ttpTo: String
    
    public var date: ITDDate?
    public var time: ITDTime?
    
    
    public enum CodingKeys: String, CodingKey {
        case ttpFrom
        case ttpTo
        case date = "itdDate"
        case time = "itdTime"
    }
    
    public static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
        switch key {
            case CodingKeys.ttpFrom:
                return .attribute
            case CodingKeys.ttpTo:
                return .attribute
            default:
                return .element
        }
    }
    
}
