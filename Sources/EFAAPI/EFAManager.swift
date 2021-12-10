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
    
    public let endpoint: String
    public let host: String
    public let languageCode: String
    
    public let session = URLSession.shared
    
    private let loader: HTTPLoader
    
    private let standardCoordinateOutputFormat: CoordinateOutputFormat = .wgs84
    
    public init(
        efaEndpoint: String,
        languageCode: String = "de",
        host: String
    ) throws {
        
        self.loader = URLSessionLoader(session)
        
        self.endpoint = efaEndpoint
        self.languageCode = languageCode
        self.host = host
        
        if endpoint.last != "/" {
            throw ConfigError.invalidEndpoint
        }
        
    }
    
    public init(
        loader: HTTPLoader,
        languageCode: String = "de"
    ) {
        self.loader = loader
        self.languageCode = languageCode
        self.endpoint = ""
        self.host = ""
    }
    
    internal func buildCommonURLRequest(
        for endpoint: QueryEndpoints,
        addition: String = ""
    ) throws -> URLRequest {
        
        guard let url = URL(string: self.endpoint + endpoint.rawValue + addition)
            else { throw EndpointError.invalidURL }
        
        let request = URLRequest(url: url)
        
        return request
    }
    
    internal func executeRequest(completion: @escaping (ITDRequest) -> ()) {
        
        guard let request = try? buildCommonURLRequest(for: .depatureMonitor) else { return }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            let decoder = XMLDecoder()
            let format = DateFormatter()
            
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if #available(iOS 10.0, *) {
                decoder.dateDecodingStrategy = .formatted(format)
            }
            
            guard let request = try? decoder.decode(ITDRequest.self, from: data) else { return }
            
            completion(request)
            
        }.resume()
        
    }
    
    public func executeStopFinderRequest(completion: @escaping (StopFinderResponse) -> ()) {
        
        guard let request = try? buildCommonURLRequest(for: .stopFinder, addition: "?name_sf=K%C3%B6nig&locationServerActive=1&type_sf=any&coordOutputFormat=WGS84%5BDD.DDDDD%5D%20&UTFMacro=1") else { return }
        
//        session.dataTaskPublisher(for: request)
        
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            
            let decoder = XMLDecoder()
            let format = DateFormatter()
            
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if #available(iOS 10.0, *) {
                decoder.dateDecodingStrategy = .formatted(format)
            }
            
            do {
                let request = try decoder.decode(StopFinderResponse.self, from: data)
                completion(request)
            } catch let error as DecodingError {
                print(error)
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
    
    public struct StandardRequestParameters: Codable {
        var isStateless: Bool = true
        var isLocationServerActive: Bool = true
        var coordinateOutputFormat: CoordinateOutputFormat = .wgs84
    }
    
    /// The output format of coordinates of the points
    public enum CoordinateOutputFormat: String, Codable {
        case wgs84 = "WGS84[DD.DDDDD]"
    }
    
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
    ///   - completion: Closure called on response
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
        
        // TOOD: Implement Object Filter
        
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = self.host
//        urlComponents.path = "/vrr/" + QueryEndpoints.stopFinder.rawValue
//        urlComponents.queryItems = [
//            URLQueryItem(name: "name_sf", value: searchText),
//            URLQueryItem(name: "locationServerActive", value: "1"),
//            URLQueryItem(name: "anyObjFilter_sf", value: "\(objectFilter.rawValue)"),
//            URLQueryItem(name: "type_sf", value: "any"),
//            URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
//            URLQueryItem(name: "UTFMacro", value: "1")
//        ]
//
//        guard let url = urlComponents.url?.absoluteURL else { return }
//
//        let request = URLRequest(url: url)
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            guard let data = data else { return }
//
//            let decoder = XMLDecoder()
//            let format = DateFormatter()
//
//            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//
//            if #available(iOS 10.0, *) {
//                decoder.dateDecodingStrategy = .formatted(format)
//            }
//
//            // TODO: Add an error callback
//
//            do {
//                let request = try decoder.decode(StopFinderResponse.self, from: data)
//                completion(request)
//            } catch let error as DecodingError {
//                print(error)
//            } catch {
//                print(error.localizedDescription)
//            }
//
//        }.resume()
        
    }
    
    public static let defaultDecoder: XMLDecoder = {
        
        let decoder = XMLDecoder()
        let format = DateFormatter()
        
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        decoder.dateDecodingStrategy = .formatted(format)
        
        return decoder
        
    }()
    
}

internal enum QueryEndpoints: String, Codable, CaseIterable {
    case stopFinder = "XML_STOPFINDER_REQUEST"
    case depatureMonitor = "XML_DM_REQUEST"
    case tripFinder = "XML_TRIP_REQUEST2"
    case additionalInformation = "XML_ADDINFO_REQUEST"
}

// MARK: - Departure Monitor

extension EFAManager {
    
    public func sendDepartureMonitorRequest(id: Station.ID) -> AnyPublisher<DepartureMonitorResponse, Error> {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = self.host
        urlComponents.path = "/vrr/" + QueryEndpoints.depatureMonitor.rawValue // TODO: Replace path component
        urlComponents.queryItems = [
            URLQueryItem(name: "name_dm", value: "\(id)"),
            URLQueryItem(name: "useRealtime", value: "1"),
            URLQueryItem(name: "locationServerActive", value: "1"),
            URLQueryItem(name: "type_dm", value: "stop"),
            URLQueryItem(name: "itdDateTimeDepArr", value: "dep"),
            URLQueryItem(name: "mode", value: "direct"),
            URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
            URLQueryItem(name: "UTFMacro", value: "1")
        ]
        
        guard let url = urlComponents.url?.absoluteURL else {
            return Fail(error: EndpointError.invalidURL).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> DepartureMonitorResponse in
                
                let decoder = XMLDecoder()
                let format = DateFormatter()
                
                decoder.dateDecodingStrategy = .formatted(format)
                
                format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                print(String(data: data, encoding: .utf8)!)
                
                do {
                    let response = try decoder.decode(DepartureMonitorResponse.self, from: data)
                    print(response)
                    return response
                } catch let error as DecodingError {
                    print(error)
                    throw error
                } catch {
                    throw error
                }
                
            }
            .eraseToAnyPublisher()
        
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
