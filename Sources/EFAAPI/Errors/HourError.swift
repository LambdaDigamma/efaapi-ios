//
//  HourError.swift
//  EFAAPI
//
//  Created by Lennart Fischer on 10.02.20.
//

import Foundation

enum HourError: Int, Codable {
    case invalidTime = -1
    case hourOutOfRange = -10
    case minuteOutOfRange = -20
}
