import Foundation
import XMLCoder
import Combine
import ModernNetworking

public enum Station {
    public typealias ID = Int
}

public protocol TransitService: AnyObject {
    
    func findTransitLocation(for searchTerm: String, filtering objectFilter: ObjectFilter) -> AnyPublisher<[TransitLocation], HTTPError>
    
}
