//
//  QueryEndpoints.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import Foundation

internal enum QueryEndpoints: String, Codable, CaseIterable {
    case stopFinder = "XML_STOPFINDER_REQUEST"
    case depatureMonitor = "XML_DM_REQUEST"
    case tripFinder = "XML_TRIP_REQUEST2"
    case additionalInformation = "XML_ADDINFO_REQUEST"
}
