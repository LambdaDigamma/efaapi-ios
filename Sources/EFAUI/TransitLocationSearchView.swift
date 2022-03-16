//
//  TransitLocationSearchView.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import SwiftUI
import EFAAPI

public struct TransitLocationSearchView: View {
    
    @ObservedObject var viewModel: TransitLocationSearchViewModel
    
    public init(viewModel: TransitLocationSearchViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        VStack {
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .opacity(0.7)
                
                TextField("Suchen…", text: $viewModel.searchTerm)
                    .textContentType(UITextContentType.location)
                    .textFieldStyle(.plain)
                
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding()
            
            ScrollView {
                
                LazyVStack {
                    
                    ForEach(viewModel.transitLocations, id: \.self) { location in
                        TransitLocationRow(transitLocation: location)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(16)
//                        Divider()
                    }
                    
                }
                .padding()
                
            }
            
        }
        .background(Color(UIColor.secondarySystemBackground))
        
    }
    
}

struct TransitLocationSearchView_Previews: PreviewProvider {
    
    static let service: TransitService = {
        
        let loader = DefaultTransitService.defaultLoader()
        let mockService = StaticTransitService()
        mockService.loadStations = {
            return [.init(name: "Hallo", description: "Test")]
        }
        let service = DefaultTransitService(loader: loader)
        
        return service
        
    }()
    
    static var previews: some View {
        
        let viewModel = TransitLocationSearchViewModel(service: Self.service)
        
        TransitLocationSearchView(viewModel: viewModel)
            .preferredColorScheme(.dark)
        
    }
}
