//
//  RouteUiState.swift
//  
//
//  Created by Lennart Fischer on 09.04.22.
//

import Foundation
import EFAAPI

public struct RouteUiState: Codable, Equatable, Hashable {
    
    public let origin: String
    public let destination: String
    public let date: Date
    public let duration: String
    public let numberOfChanges: Int
    
    public var partialRoutes: [PartialRouteUiState]
    
}

public struct PartialRouteUiState: Codable, Equatable, Hashable, Identifiable {
    
    public var id = UUID()
    public let transportType: TransportTypeUi
    public let from: Point
    public let to: Point
    public let timeInMinutes: Int
    public let line: String
    public let lineDestination: String
    
    public let footPathAfter: FootPathRouteUiState?
    
    /// Distance in meters
    public let distance: Int?
    
    public init(
        id: UUID = UUID(),
        transportType: TransportTypeUi,
        from: Point,
        to: Point,
        timeInMinutes: Int,
        distance: Int?,
        line: String,
        lineDestination: String,
        footPathAfter: FootPathRouteUiState? = nil
    ) {
        self.id = id
        self.transportType = transportType
        self.from = from
        self.to = to
        self.timeInMinutes = timeInMinutes
        self.distance = distance
        self.line = line
        self.lineDestination = lineDestination
        self.footPathAfter = footPathAfter
    }
    
    public struct Point: Codable, Equatable, Hashable {
        public let stationName: String
        public let targetDate: Date
        public let realtimeDate: Date?
        public let platform: String
    }
    
    var targetDuration: DateInterval {
        return DateInterval(start: from.targetDate, end: to.targetDate)
    }
    
    var realtimeDuration: DateInterval {
        let start = from.realtimeDate ?? from.targetDate
        let end = to.realtimeDate ?? to.targetDate
        return DateInterval(start: start, end: end)
    }
    
}

public struct FootPathRouteUiState: Codable, Equatable, Hashable {
    
    public let text: String
    
}

protocol RouteDetailPresentable {
    
    func transformIntoUiState(origin: String, destination: String) -> RouteUiState
    
}

extension ITDRoute: RouteDetailPresentable {
    
    func transformIntoUiState(origin: String, destination: String) -> RouteUiState {
        
        let partialRoutes = self.partialRouteList
            .partialRoutes
            .compactMap({ (partialRoute: ITDPartialRoute) -> PartialRouteUiState? in
                
                guard let from = partialRoute.points.first?.transformToPoint(),
                        let to = partialRoute.points.last?.transformToPoint() else {
                    return nil
                }
                
                return PartialRouteUiState(
                    transportType: partialRoute.meansOfTransport.motType.toUiType(),
                    from: from,
                    to: to,
                    timeInMinutes: partialRoute.timeMinute,
                    distance: partialRoute.distance ?? 0,
                    line: partialRoute.meansOfTransport.symbol,
                    lineDestination: partialRoute.meansOfTransport.destination,
                    footPathAfter: partialRoute.footPathInfo != nil ? FootPathRouteUiState(
                        text: String(describing: partialRoute.footPathInfo)
                    ) : nil
                )
                
            })
        
        return RouteUiState(
            origin: origin,
            destination: destination,
            date: self.targetStartDate ?? Date(),
            duration: self.publicDuration,
            numberOfChanges: self.numberOfChanges,
            partialRoutes: partialRoutes
        )
        
    }
    
}

extension ITDPoint {
    
    func transformToPoint() -> PartialRouteUiState.Point {
        
        return PartialRouteUiState.Point(
            stationName: self.name,
            targetDate: self.targetDateTime.parsedDate ?? Date(),
            realtimeDate: self.dateTime.parsedDate ?? nil,
            platform: self.platformName
        )
        
    }
    
}
