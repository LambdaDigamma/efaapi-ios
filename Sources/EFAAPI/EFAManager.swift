import Foundation
import XMLCoder

public class EFAManager {
    
    public let endpoint: String
    public let host: String
    public let languageCode: String
    
    private let standardCoordinateOutputFormat: CoordinateOutputFormat = .wgs84
    
    public init(efaEndpoint: String,
                languageCode: String = "de",
                host: String) throws {
        self.endpoint = efaEndpoint
        self.languageCode = languageCode
        self.host = host
        
        if endpoint.last != "/" {
            throw ConfigError.invalidEndpoint
        }
        
    }
    
    public enum QueryEndpoints: String, Codable, CaseIterable {
        case stopFinder = "XML_STOPFINDER_REQUEST"
        case depatureMonitor = "XML_DM_REQUEST"
        case tripFinder = "XML_TRIP_REQUEST2"
        case additionalInformation = "XML_ADDINFO_REQUEST"
    }
    
    public func depatureMonitorRequest() {
        
        
        
    }
    
    public func buildCommonURLRequest(for endpoint: QueryEndpoints, addition: String = "") throws -> URLRequest {
        
        guard let url = URL(string: self.endpoint + endpoint.rawValue + addition)
            else { throw EndpointError.invalidURL }
        
        let request = URLRequest(url: url)
        
        
        
        
        return request
        
    }
    
    public func executeRequest(completion: @escaping (ITDRequest) -> ()) {
        
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
    
    public enum CoordinateOutputFormat: String, Codable {
        case wgs84 = "WGS84[DD.DDDDD]"
    }
    
    
    
    public func sendStopFinderRequest(searchText: String, completion: @escaping (StopFinderResponse) -> ()) {
        
        do {
            
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = self.host
            urlComponents.path = "/vrr/" + QueryEndpoints.stopFinder.rawValue
            urlComponents.queryItems = [
                URLQueryItem(name: "name_sf", value: searchText),
                URLQueryItem(name: "locationServerActive", value: "1"),
                URLQueryItem(name: "type_sf", value: "any"),
                URLQueryItem(name: "coordOutputFormat", value: CoordinateOutputFormat.wgs84.rawValue),
                URLQueryItem(name: "UTFMacro", value: "1")
            ]
            
            guard let url = urlComponents.url?.absoluteURL else { return }
            
            print(url)
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let data = data else { return }
                
                print(String(data: data, encoding: .utf8))
                
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
            
            
        } catch {
            print(error.localizedDescription)
        }
        
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
