import Foundation
import XMLCoder
import Combine
import ModernNetworking

public enum Station {
    public typealias ID = Int
}

// TODO: Delay
// enum Delay: Codable {
//
// }

public class EFAManager {
    
    public let languageCode: String
    private let loader: HTTPLoader
    
    private let standardCoordinateOutputFormat: CoordinateOutputFormat = .wgs84
    
    public init(
        loader: HTTPLoader,
        languageCode: String = "de"
    ) {
        self.loader = loader
        self.languageCode = languageCode
    }
    
//    internal func buildCommonURLRequest(
//        for endpoint: QueryEndpoints,
//        addition: String = ""
//    ) throws -> URLRequest {
//
//        guard let url = URL(string: self.endpoint + endpoint.rawValue + addition)
//            else { throw EndpointError.invalidURL }
//
//        let request = URLRequest(url: url)
//
//        return request
//    }
    
    public struct StandardRequestParameters: Codable {
        var isStateless: Bool = true
        var isLocationServerActive: Bool = true
        var coordinateOutputFormat: CoordinateOutputFormat = .wgs84
    }
    
    public static let defaultDecoder: XMLDecoder = {
        
        let decoder = XMLDecoder()
        let format = DateFormatter()
        
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        decoder.dateDecodingStrategy = .formatted(format)
        
        return decoder
        
    }()
    
}

// MARK: - Stop Finder

extension EFAManager {
    
    /// Send a stop finder request with a specified search text
    /// and receive a stop finder response.
    ///
    ///
    /// - Parameters:
    ///   - searchText: Search term
    ///   - objectFilter: Specifies the stop types returned by the api (`ObjectFilter`)
    /// - Returns: The stop finder response publisher
    public func sendStopFinderRequest(
        searchText: String,
        objectFilter: ObjectFilter = .noFilter
    ) -> AnyPublisher<StopFinderResponse, HTTPError> {
        
        var request = HTTPRequest(
            method: .get,
            path: "/vrr/" + QueryEndpoints.stopFinder.rawValue
        )
        
        request.queryItems = [
            URLQueryItem(name: "name_sf", value: searchText),
            URLQueryItem(name: "locationServerActive", value: "1"),
            URLQueryItem(name: "anyObjFilter_sf", value: "\(objectFilter.rawValue)"),
            URLQueryItem(name: "type_sf", value: "any"),
            URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
            URLQueryItem(name: "UTFMacro", value: "1")
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
    
}

// MARK: - Departure Monitor

extension EFAManager {
    
    public func sendDepartureMonitorRequest(id: Station.ID) -> AnyPublisher<DepartureMonitorResponse, HTTPError> {
        
        var request = HTTPRequest(
            method: .get,
            path: "/vrr/" + QueryEndpoints.depatureMonitor.rawValue
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
        
}


extension EFAManager {
    
    public enum ConfigError: Error {
        case invalidEndpoint
    }
    
    public enum EndpointError: Error {
        case invalidURL
    }
    
}
