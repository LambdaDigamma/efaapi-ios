//
//  TransitLocation.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable, Hashable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude
            && lhs.latitude == rhs.latitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.latitude)
        hasher.combine(self.longitude)
    }
    
}

public class TransitLocation: ObservableObject, Hashable, Equatable {
    
    public var stationID: Station.ID?
    public var locationType: TransitLocationType
    public var name: String
    public var description: String
    public var coordinates: CLLocationCoordinate2D? = nil
    
    public init(odvNameElement: ODVNameElement) {
        
        self.stationID = odvNameElement.stopID ?? odvNameElement.id
        self.locationType = odvNameElement.anyType ?? .location
        self.name = odvNameElement.name
        self.description = "\(odvNameElement.locality ?? "") \(odvNameElement.streetName ?? "") \(odvNameElement.buildingNumber ?? "")"
        
        if let latitude = odvNameElement.lat, let longitude = odvNameElement.lng {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
    }
    
    public init(
        stationID: Station.ID? = nil,
        locationType: TransitLocationType = .location,
        name: String,
        description: String,
        coordinates: CLLocationCoordinate2D? = nil
    ) {
        self.stationID = stationID
        self.locationType = locationType
        self.name = name
        self.description = description
        self.coordinates = coordinates
    }
    
    public static func == (lhs: TransitLocation, rhs: TransitLocation) -> Bool {
        return lhs.stationID == rhs.stationID
            && lhs.locationType == rhs.locationType
            && lhs.name == rhs.name
            && lhs.description == rhs.description
            && lhs.coordinates == rhs.coordinates
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stationID)
        hasher.combine(locationType)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(coordinates)
    }
    
}
