//
//  TripConfigurationScreen.swift
//  
//
//  Created by Lennart Fischer on 03.04.22.
//

import SwiftUI
import EFAAPI

public struct TripConfigurationScreen: View {
    
    @State var showSelectOrigin = false
    @State var showSelectDestination = false
    @State var origin: TransitLocation?
    @State var destination: TransitLocation?
    
    private let transitService: DefaultTransitService
    
    @StateObject var selectOriginViewModel: TransitLocationSearchViewModel
    @StateObject var selectDestinationViewModel: TransitLocationSearchViewModel
    
    public init(
        transitService: DefaultTransitService
    ) {
        self.transitService = transitService
        self._selectOriginViewModel = .init(
            wrappedValue: TransitLocationSearchViewModel(service: transitService)
        )
        self._selectDestinationViewModel = .init(
            wrappedValue: TransitLocationSearchViewModel(service: transitService)
        )
    }
    
    public var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
//                Text("Fahrt planen")
//                    .font(.largeTitle)
//                    .fontWeight(.semibold)
                
                Text("From")
                
                HStack {
                    
                    Button(action: openSelectOrigin) {
                        Text(origin?.name ?? "Abfahrt auswählen")
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.secondarySystemFill))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {}) {
                        Text("\(Image(systemName: "mappin.and.ellipse"))")
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.secondarySystemFill))
                            .cornerRadius(12)
                    }
                    .frame(maxWidth: 60)
                    
                }
                
                Text("To")
                
                HStack {
                    
                    Button(action: openSelectDestination) {
                        Text(destination?.name ?? "Ziel auswählen")
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.secondarySystemFill))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {}) {
                        Text("\(Image(systemName: "arrow.up.arrow.down"))")
                            .fontWeight(.semibold)
                            .foregroundColor(.yellow)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.secondarySystemFill))
                            .cornerRadius(12)
                    }
                    .frame(maxWidth: 60)
                    
                }
                
                Button(action: {}) {
                    Text("Verbindung suchen")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemYellow))
                        .cornerRadius(12)
                }
                
                Spacer()
                    .frame(idealHeight: 200)
                
                favorites()
                    .padding(.top, 60)
                
                disclaimer()
                
            }
            .padding()
            
        }
        .navigationTitle(Text("Auskunft"))
        .sheet(isPresented: $showSelectOrigin) {
            TransitLocationSearchView(viewModel: selectOriginViewModel) { (location: TransitLocation) in
                self.origin = location
            }
        }
        .sheet(isPresented: $showSelectDestination) {
            TransitLocationSearchView(viewModel: selectDestinationViewModel) { (location: TransitLocation) in
                self.destination = location
            }
        }
        
    }
    
    @ViewBuilder
    private func favorites() -> some View {
        
        VStack(spacing: 8) {
            
            HStack {
                
                Text("Favoriten")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button(action: {}) {
                    Text("Alle \(Image(systemName: "chevron.right"))")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.yellow)
                
            }.padding(.horizontal)
            
            favoriteRow(
                title: "Zur Arbeit",
                origin: "Moers",
                destination: "Aachen",
                accentColor: .red,
                systemImageName: "bag"
            )
            
            favoriteRow(
                title: "Nach Hause",
                origin: "Aachen",
                destination: "Moers"
            )
            
        }
        
    }
    
    @ViewBuilder
    private func disclaimer() -> some View {
        
        VStack(alignment: .leading) {
            
            Text("Du kannst keine Tickets über diese App kaufen, da es keine Möglichkeit der Integration gibt.")
                .font(.caption)
                .foregroundColor(.secondary)
            
        }
        .padding(.top)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    @ViewBuilder
    private func favoriteRow(
        title: String,
        origin: String,
        destination: String,
        accentColor: Color = .yellow,
        onAccentColor: Color = .black,
        systemImageName: String = "house"
    ) -> some View {
        
        HStack(spacing: 16) {
            
            Circle()
                .fill(accentColor)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxHeight: 50)
                .overlay(ZStack {
                    Image(systemName: systemImageName)
                        .foregroundColor(onAccentColor)
                })
                
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                
                Text("\(origin) \(Image(systemName: "arrow.right")) \(destination)")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
            }
            
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 8)
//        .background(Color.yellow.opacity(0.3))
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(12)
        
    }
    
    // MARK: - Actions -
    
    private func openSelectOrigin() {
        
        showSelectOrigin = true
        
    }
    
    private func openSelectDestination() {
        
        showSelectDestination = true
        
    }
    
    private func search() {
        
        guard let originID = origin?.stationID, let destinationID = destination?.stationID else {
            return
        }
        
        
        
//        transitService.sendTripRequest(origin: originID, destination: destinationID)
//            .sink { (completion: Subscribers.Completion<HTTPError>) in
//
//            } receiveValue: { (response: TripResponse) in
//
//            }
//            .store(in: &cancellables)


        
    }
    
}

struct TripConfigurationScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            TripConfigurationScreen(
                transitService: DefaultTransitService(
                    loader: DefaultTransitService.defaultLoader()
                )
            )
        }.preferredColorScheme(.dark)
    }
    
}
