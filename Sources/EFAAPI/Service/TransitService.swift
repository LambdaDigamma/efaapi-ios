import Foundation
import XMLCoder
import Combine
import ModernNetworking
import CoreLocation

public enum Station {
    public typealias ID = Int
}

public protocol TransitService: AnyObject {
    
    func findTransitLocation(for searchTerm: String, filtering objectFilter: ObjectFilter) -> AnyPublisher<[TransitLocation], HTTPError>
    
    func departureMonitor(
        id: Station.ID
    ) -> AnyPublisher<DepartureMonitorData, Error>
    
    func findTransitLocation(
        for coordinate: CLLocationCoordinate2D,
        filtering objectFilter: ObjectFilter,
        maxNumberOfResults: Int
    ) -> AnyPublisher<[TransitLocation], HTTPError>
    
    func sendTripRequest(
        origin: String,
        destination: String,
        config: TripRequest.Configuration,
        tripDateTimeType: TripDateTimeType
    ) -> AnyPublisher<TripResponse, HTTPError>
    
    func geoObject(
        lines: [LineIdentifiable]
    ) -> AnyPublisher<GeoITDRequest, HTTPError>
    
}
