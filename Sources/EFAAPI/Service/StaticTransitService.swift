//
//  StaticTransitService.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import Foundation
import ModernNetworking
import Combine
import CoreLocation

public class StaticTransitService: TransitService {
    
    public var loadStations: () -> ([TransitLocation])
    
    public init() {
        self.loadStations = {
            return []
        }
    }
    
    public func findTransitLocation(
        for searchTerm: String,
        filtering objectFilter: ObjectFilter
    ) -> AnyPublisher<[TransitLocation], HTTPError> {
    
        return Just(loadStations())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
        
    }
    
    public func findTransitLocation(
        for coordinate: CLLocationCoordinate2D,
        filtering objectFilter: ObjectFilter,
        maxNumberOfResults: Int
    ) -> AnyPublisher<[TransitLocation], HTTPError> {
        
        return Just(loadStations())
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
        
    }
    
    public func departureMonitor(id: Station.ID) -> AnyPublisher<DepartureMonitorData, Error> {
        
        let departureMonitor = DepartureMonitorData(
            date: .init(),
            name: "Duisburg Hbf",
            departures: [
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.actualDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 2)))
                        .setting(\.servingLine.direction, to: "Münster (Westf) Hbf")
                        .setting(\.servingLine.symbol, to: "S1")
                ),
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.regularDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 5)))
                        .setting(\.servingLine.direction, to: "Dortmund Hbf")
                        .setting(\.servingLine.symbol, to: "ICE 933")
                ),
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.regularDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 10)))
                        .setting(\.servingLine.direction, to: "Rheurdt Kirche")
                        .setting(\.servingLine.symbol, to: "SB 30")
                        .setting(\.platformName, to: "1")
                ),
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.regularDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 20)))
                        .setting(\.servingLine.direction, to: "Duisburg Ruhrau")
                        .setting(\.servingLine.symbol, to: "RE 1")
                )
            ]
        )
        
        return Just(departureMonitor)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
    }
    
}
