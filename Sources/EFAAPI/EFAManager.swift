import Foundation
import XMLCoder

public class EFAManager {
    
    public let endpoint: String
    public let languageCode: String
    
    public init(efaEndpoint: String,
                languageCode: String = "de") throws {
        self.endpoint = efaEndpoint
        self.languageCode = languageCode
        
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
    
    public func buildCommonURLRequest(for endpoint: QueryEndpoints) throws -> URLRequest {
        
        guard let url = URL(string: self.endpoint + endpoint.rawValue)
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
    
    public struct StandardRequestParameters: Codable {
        var isStateless: Bool = true
        var isLocationServerActive: Bool = true
        var coordinateOutputFormat: CoordinateOutputFormat = .wgs84
        
    }
    
    public enum CoordinateOutputFormat: String, Codable {
        case wgs84 = "WGS84[DD.DDDDD]"
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
