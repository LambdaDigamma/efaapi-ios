//
//  SwiftUIView.swift
//  
//
//  Created by Lennart Fischer on 04.04.22.
//

import SwiftUI
import EFAAPI
import Combine
import ModernNetworking

public class TripRouteViewModel: ObservableObject, Identifiable {
    
    @Published var duration: String
    
    public var id: UUID = UUID()
    
    public init(
        duration: String
    ) {
        self.duration = duration
        
        
    }
    
}

public class TripSearchResultsViewModel: ObservableObject {
    
    @Published var originID: Stop.ID
    @Published var destinationID: Stop.ID
    
    @Published var error: HTTPError?
    @Published var startTime: Date?
//    @Published var startTime: Date?
    @Published var request: TripRequest?
    @Published var routes: [ITDRoute] = []
    
    @Published var routesViewModel: [TripRouteViewModel] = []
    
    private let transitService: DefaultTransitService
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        originID: Stop.ID,
        destinationID: Stop.ID,
        transitService: DefaultTransitService
    ) {
        self.originID = originID
        self.destinationID = destinationID
        self.transitService = transitService
    }
    
    public func search() {
        
        transitService.sendTripRequest(origin: originID, destination: destinationID)
            .sink { (completion: Subscribers.Completion<HTTPError>) in
                
                switch completion {
                    case .failure(let error):
                        self.error = error
                    default: break
                }
                
            } receiveValue: { (response: TripResponse) in
                
                self.request = response.tripRequest
                self.routes = response.tripRequest.itinerary.routeList?.routes ?? []
                
                let routes = response.tripRequest.itinerary.routeList?.routes ?? []
                
                self.routesViewModel = routes
                    .sorted(by: { $0.routeIndex < $1.routeIndex })
                    .map { (route: ITDRoute) in
                    
                        return TripRouteViewModel(
                            duration: route.publicDuration
                        )
                        
                    }
                
            }
            .store(in: &cancellables)
        
    }
    
}

public struct TripSearchResultsScreen: View {
    
    @ObservedObject var viewModel: TripSearchResultsViewModel
    
    public init(
        viewModel: TripSearchResultsViewModel
    ) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        ScrollView {
            
            LazyVStack(spacing: 20) {

                if let error = viewModel.error {
                    Text(error.underlyingError?.localizedDescription ?? "")
                    
                    if let underlyingError = error.underlyingError, let decodingError = underlyingError as? DecodingError {
                        Text(decodingError.recoverySuggestion ?? "")
                        Text(decodingError.failureReason ?? "")
                        Text(decodingError.errorDescription ?? "")
                    }
                }
                
                if let tripRequest = viewModel.request {
                    
                    if let start = tripRequest.odv.filter({ $0.usage == .origin }).first {
                        Text("\(start.name?.elements?.first?.name ?? "")")
                    }
                    
                }
                
                HStack {
                    Text("\(viewModel.originID)")
                    Spacer()
                    Text("\(viewModel.destinationID)")
                }
                
                ForEach(viewModel.routes) { route in
                    
                    VStack(alignment: .leading) {
                        
                        ForEach(route.partialRouteList.partialRoutes, id: \.self) { partialRoute in
                            
                            HStack {
                                
                                if let type = partialRoute.meansOfTransport.motType {
                                    
                                    HStack {
                                        TransportIcon.icon(for: type)
                                        Text("\(partialRoute.meansOfTransport.shortName)")
                                    }
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color(UIColor.secondarySystemFill))
                                    .cornerRadius(8)
                                    .font(.footnote.weight(.semibold))
                                    
                                }
                                
                                if let origin = partialRoute.points.first, let destination = partialRoute.points.last {
                                    Text("\(origin.name)")
                                        .font(.footnote.weight(.semibold))
                                    + Text(" \(Image(systemName: "arrow.right")) ") + Text("\(destination.name)")
                                        .font(.footnote.weight(.semibold))
                                }
                                
//                                if let destination = partialRoute.points.last {
//                                    Text("\(destination.name)")
//                                        .font(.footnote.weight(.semibold))
//                                }
                                
                                
                                
                            }
                            
                        }
                        
                        Text("\(route.publicDuration)")
                        Text("Umst. \(route.numberOfChanges)")
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                }
                
            }
            .padding()
            
        }
        .onAppear {
            viewModel.search()
        }
        
    }
    
}

struct TripSearchResultsScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        let service = DefaultTransitService(loader: DefaultTransitService.defaultLoader())
        let viewModel = TripSearchResultsViewModel(
            originID: 20036308,
            destinationID: 20016032,
            transitService: service
        )
        
        TripSearchResultsScreen(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}
