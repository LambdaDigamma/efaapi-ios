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

public extension Collection where Element == ITDPoint {
    
    var usageDeparture: ITDPoint? {
        return self.first(where: { $0.usage == .departure })
    }
    
    var usageArrival: ITDPoint? {
        return self.first(where: { $0.usage == .arrival })
    }
    
}

public extension Collection where Element == ODV {
    
    var origin: ODV? {
        return self.first(where: { $0.usage == .origin })
    }
    
    var destination: ODV? {
        return self.first(where: { $0.usage == .destination })
    }
    
}

public extension ITDRoute {
    
    var time: String {
        
        guard let firstDeparture = self.partialRouteList.partialRoutes.first?.points.usageDeparture,
              let lastArrival = self.partialRouteList.partialRoutes.last?.points.usageArrival else {
            return ""
        }
        
        return "\(firstDeparture.dateTime.time?.formatted ?? "")-\(lastArrival.dateTime.time?.formatted ?? "")"
        
    }
    
}

public extension TripRequest {
    
    var origin: String {
        return odv
            .origin?
            .assignedStops?
            .stops
            .first?
            .name ?? ""
    }
    
    var destination: String {
        return odv
            .destination?
            .assignedStops?
            .stops
            .first?
            .name ?? ""
    }
    
}

//public extension Collection where Element == ITDRoute {
//
//    var time: String {
//
//        self.
//
//    }
//
//}

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
                    
                    if let dateTime = tripRequest.tripDateTime.dateTime.parsedDate {
                        
                        HStack {
                            Text("\(tripRequest.tripDateTime.depArrType.localized): ") +
                            Text("\(dateTime, style: .date)") + Text(" ") +
                            Text("\(dateTime, style: .time)")
                        }
                        
                        
                    }
                    
                    HStack {
                        Text(tripRequest.origin) + Text(" \(Image(systemName: "arrow.right")) ") + Text(tripRequest.destination)
                    }
                    
                }
                
                Divider()
                
                ForEach(viewModel.routes) { route in
                    
                    row(route: route)
                    
                }
                
            }
            .padding()
            
        }
        .onAppear {
            viewModel.search()
        }
        
    }
    
    @ViewBuilder
    private func row(route: ITDRoute) -> some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                Text(route.time)
                
                Text("\(route.publicDuration)")
                
                Spacer()
                
                Text("Umst. \(route.numberOfChanges)")
                
            }
            
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
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        
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
