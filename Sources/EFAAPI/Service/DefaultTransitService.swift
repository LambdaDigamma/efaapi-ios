//
//  DefaultEFAService.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import Foundation
import XMLCoder
import Combine
import ModernNetworking

public class DefaultTransitService: TransitService {
    
    private let languageCode: String
    private let loader: HTTPLoader
    private let standardCoordinateOutputFormat: CoordinateOutputFormat = .wgs84
    
    public init(
        loader: HTTPLoader,
        languageCode: String = "de"
    ) {
        self.loader = loader
        self.languageCode = languageCode
    }
    
    // MARK: - Stop Finder
    
    /// Send a stop finder request with a specified search text
    /// and receive a stop finder response.
    ///
    /// - Parameters:
    ///   - searchText: Search term
    ///   - objectFilter: Specifies the stop types returned by the api (`ObjectFilter`)
    /// - Returns: The stop finder response publisher
    public func sendRawStopFinderRequest(
        searchText: String,
        objectFilter: ObjectFilter = .noFilter,
        maxNumberOfResults: Int = 50
    ) -> AnyPublisher<StopFinderResponse, HTTPError> {
        
        var request = HTTPRequest(
            method: .get,
            path: QueryEndpoints.stopFinder.rawValue
        )
        
        request.queryItems = [
            URLQueryItem(name: "name_sf", value: searchText),
            URLQueryItem(name: "locationServerActive", value: "1"),
            URLQueryItem(name: "anyObjFilter_sf", value: "\(objectFilter.rawValue)"),
            URLQueryItem(name: "type_sf", value: "any"),
            URLQueryItem(name: "anyMaxSizeHitList", value: "\(maxNumberOfResults)"),
            URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
            URLQueryItem(name: "UTFMacro", value: "1"),
        ]
        
        return Deferred {
            
            return Future<StopFinderResponse, HTTPError> { promise in
                
                self.loader.load(request) { (result: HTTPResult) in
                    
                    result.decodingXML(
                        StopFinderResponse.self,
                        decoder: Self.defaultDecoder
                    ) { (result: Result<StopFinderResponse, HTTPError>) in
                        
                        switch result {
                            case .success(let response):
                                promise(.success(response))
                            case .failure(let error):
                                promise(.failure(error))
                        }
                        
                    }
                    
                }
                
            }
            
        }.eraseToAnyPublisher()
        
    }
    
    public func findTransitLocation(
        for searchTerm: String,
        filtering objectFilter: ObjectFilter
    ) -> AnyPublisher<[TransitLocation], HTTPError> {
        
        self.sendRawStopFinderRequest(searchText: searchTerm, objectFilter: objectFilter)
            .map({ (response: StopFinderResponse) in
                return response.stopFinderRequest
                    .odv
                    .name?
                    .elements?
                    .sorted(by: { $0.matchQuality > $1.matchQuality })
                    .map({ TransitLocation(odvNameElement: $0) }) ?? []
            })
            .replaceEmpty(with: [])
            .eraseToAnyPublisher()
        
    }
    
    // MARK: - Departure Monitor
    
    public func sendRawDepartureMonitorRequest(
        id: Station.ID
    ) -> AnyPublisher<DepartureMonitorResponse, HTTPError> {
        
        var request = HTTPRequest(
            method: .get,
            path: QueryEndpoints.depatureMonitor.rawValue
        )
        
        request.queryItems = [
            URLQueryItem(name: "name_dm", value: "\(id)"),
            URLQueryItem(name: "useRealtime", value: "1"),
            URLQueryItem(name: "locationServerActive", value: "1"),
            URLQueryItem(name: "type_dm", value: "stop"),
            URLQueryItem(name: "itdDateTimeDepArr", value: "dep"),
            URLQueryItem(name: "mode", value: "direct"),
            URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
            URLQueryItem(name: "UTFMacro", value: "1")
        ]
        
        return Deferred {
            
            return Future<DepartureMonitorResponse, HTTPError> { promise in
                
                self.loader.load(request) { (result: HTTPResult) in
                    
                    result.decodingXML(
                        DepartureMonitorResponse.self,
                        decoder: Self.defaultDecoder
                    ) { (result: Result<DepartureMonitorResponse, HTTPError>) in
                        
                        switch result {
                            case .success(let response):
                                promise(.success(response))
                            case .failure(let error):
                                promise(.failure(error))
                        }
                        
                    }
                    
                }
                
            }
            
        }.eraseToAnyPublisher()
        
    }
    
    public enum TripDateTimeType: String {
        case departure = "dep"
        case arrival = "arr"
    }
    
    public func sendTripRequest(
        origin: Stop.ID,
        destination: Stop.ID,
        tripDateTimeType: TripDateTimeType = .departure
    ) -> AnyPublisher<TripResponse, HTTPError> {
        
        var request = HTTPRequest(
            method: .get,
            path: QueryEndpoints.tripFinder.rawValue
        )
        
//    https://openservice.vrr.de/vrr/XML_TRIP_REQUEST2?
//        locationServerActive=1&
//        sessionID=0
//        &type_origin=any
//        &name_origin=20036308
//        &type_destination=any
//        &name_destination=20016032
//        &UTFMacro=1
        
        request.queryItems = [
            URLQueryItem(name: "useRealtime", value: "1"),
            URLQueryItem(name: "locationServerActive", value: "1"),
            URLQueryItem(name: "name_origin", value: "\(origin)"),
            URLQueryItem(name: "name_destination", value: "\(destination)"),
            URLQueryItem(name: "type_origin", value: "any"),
            URLQueryItem(name: "type_destination", value: "any"),
            URLQueryItem(name: "itdTripDateTimeDepArr", value: tripDateTimeType.rawValue),
            URLQueryItem(name: "mode", value: "direct"),
            URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
            URLQueryItem(name: "UTFMacro", value: "1")
        ]
        
        return Deferred {
            
            return Future<TripResponse, HTTPError> { promise in
                
                self.loader.load(request) { (result: HTTPResult) in
                    
                    result.decodingXML(
                        TripResponse.self,
                        decoder: Self.defaultDecoder
                    ) { (result: Result<TripResponse, HTTPError>) in
                        
                        switch result {
                            case .success(let response):
                                promise(.success(response))
                            case .failure(let error):
                                promise(.failure(error))
                        }
                        
                    }
                    
                }
                
            }
            
        }.eraseToAnyPublisher()
        
//        return Deferred {
            
//        https://openservice.vrr.de/vrr/XML_TRIP_REQUEST2?locationServerActive=1&sessionID=0&type_origin=any&name_origin=Duisburg Hbf &type_destination=any&name_destination=Aachen Hbf
//
//            return Future<DepartureMonitorResponse, HTTPError> { promise in
//
//                self.loader.load(request) { (result: HTTPResult) in
//
//                    result.decodingXML(
//                        DepartureMonitorResponse.self,
//                        decoder: Self.defaultDecoder
//                    ) { (result: Result<DepartureMonitorResponse, HTTPError>) in
//
//                        switch result {
//                            case .success(let response):
//                                promise(.success(response))
//                            case .failure(let error):
//                                promise(.failure(error))
//                        }
//
//                    }
//
//                }
//
//            }
//
//        }.eraseToAnyPublisher()
        
    }
    
    // MARK: - Helpers
    
    public static let defaultDecoder: XMLDecoder = {
        
        let decoder = XMLDecoder()
        let format = DateFormatter()
        
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
//        decoder.
        decoder.dateDecodingStrategy = .formatted(format)
        
        return decoder
        
    }()
    
    public static func defaultLoader() -> HTTPLoader {
        
        let environment = ServerEnvironment(scheme: "https", host: "openservice.vrr.de", pathPrefix: "/vrr")
        
        let resetGuard = ResetGuardLoader()
        let applyEnvironment = ApplyEnvironmentLoader(environment: environment)
        let session = URLSession(configuration: .default)
        let sessionLoader = URLSessionLoader(session)
        let printLoader = PrintLoader()
        
        return (resetGuard --> applyEnvironment --> printLoader --> sessionLoader)!
        
    }
    
}
