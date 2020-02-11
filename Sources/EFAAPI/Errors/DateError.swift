//
//  DateError.swift
//  EFAAPI
//
//  Created by Lennart Fischer on 10.02.20.
//

import Foundation

public enum DateError: Int, Codable {
    case invalidDate = -1
    case yearOutOfRange = -10
    case monthOutOfRange = -20
    case dayOutOfRange = -30
    case dateOutsideOfSchedulePeriod = -4001
}
