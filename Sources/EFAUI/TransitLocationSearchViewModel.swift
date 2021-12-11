//
//  TransitLocationSearchViewModel.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import Foundation
import Combine
import EFAAPI
import ModernNetworking

public class TransitLocationSearchViewModel: ObservableObject {
    
    private let service: TransitService
    
    @Published public var searchTerm: String = ""
    @Published public var transitLocations: [TransitLocation] = []
    
    public init(service: TransitService) {
        self.service = service
        
        $searchTerm
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (search) -> String? in
                if search.count < 1 {
                    self.transitLocations = []
                    return nil
                }
                
                return search
            })
            .compactMap{ $0 }
            .sink(receiveValue: { (search) in
                
                self.searchStation(searchText: search)
                
                print(self.searchTerm)
//                if !self.searchText.isEmpty {
//                    self.filteredData = self.allData.
//                    filter { $0.contains(str) }
//                } else {
//                    self.filteredData = self.allData
//                }
            }).store(in: &cancellables)
        
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func searchStation(searchText: String) {
        
        service.findTransitLocation(for: searchText, filtering: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion: Subscribers.Completion<HTTPError>) in
                
                switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    default: break
                }
                
            }, receiveValue: { (transitLocations: [TransitLocation]) in
                self.transitLocations = transitLocations
            })
            .store(in: &cancellables)
        
    }
    
    struct StationViewModel: Identifiable {
        var id: UUID = UUID()
        var name: String
        var description: String
        
        public let odvElement: ODVNameElement
        
        init(element: ODVNameElement) {
            self.odvElement = element
            self.name = element.name
            self.description = ObjectFilter.displayName(element.type ?? .noFilter)
        }
    }
    
}
