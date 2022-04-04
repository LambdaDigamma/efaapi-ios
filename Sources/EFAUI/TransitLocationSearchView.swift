//
//  TransitLocationSearchView.swift
//  
//
//  Created by Lennart Fischer on 10.12.21.
//

import SwiftUI
import EFAAPI

#if canImport(UIKit)

public struct TransitLocationSearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TransitLocationSearchViewModel
    
    private let onSelectTransitStation: (TransitLocation) -> Void
    
    public init(
        viewModel: TransitLocationSearchViewModel,
        onSelectTransitStation: @escaping (TransitLocation) -> Void = { _ in }
    ) {
        self.viewModel = viewModel
        self.onSelectTransitStation = onSelectTransitStation
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
                            .onTapGesture {
                                self.onSelectTransitStation(location)
                                self.presentationMode.wrappedValue.dismiss()
                            }
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

#endif
