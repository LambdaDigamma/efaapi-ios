//
//  TripSearchScreen.swift
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
    
    var startDate: Date? {
        return self.partialRouteList.partialRoutes.first?.points.usageDeparture?.dateTime.parsedDate
    }
    
    var endDate: Date? {
        return self.partialRouteList.partialRoutes.first?.points.usageArrival?.dateTime.parsedDate
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

public struct TripSearchScreen: View {
    
    @ObservedObject var viewModel: TripSearchViewModel
    
    public init(
        viewModel: TripSearchViewModel
    ) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        VStack(spacing: 0) {
            
            topInfoBar()
            
            Divider()
            
            emptyState()
            valueState()
            errorState()
            
        }
        .onAppear {
            viewModel.search()
        }
        
    }
    
    @ViewBuilder
    private func topInfoBar() -> some View {
        
        let dateTime = viewModel.result.value?.tripDateTime.dateTime.parsedDate ?? Date()
        let depArrType = viewModel.result.value?.tripDateTime.depArrType ?? .departure
        
        let modePlaceholder = viewModel.result.value == nil
        
        HStack {
            Text("\(depArrType.localized): ") +
            Text("\(dateTime, style: .date)") + Text(" ") +
            Text("\(dateTime, style: .time)")
        }
        .redacted(reason: modePlaceholder ? [.placeholder] : [])
        
        HStack {
            
//                viewModel.origin?.name ?? ""
            
//            Text(tripRequest.origin) + Text(" \(Image(systemName: "arrow.right")) ") + Text(tripRequest.destination)
        }
        
    }
    
    @ViewBuilder
    private func emptyState() -> some View {
        
        viewModel.result.isEmpty() {
            
            ZStack {
                Text("Starte Deine Suche")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        
    }
    
    @ViewBuilder
    private func loadingState() -> some View {
        
        viewModel.result.isLoading {
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
        }
        
    }
    
    @ViewBuilder
    private func valueState() -> some View {
        
        viewModel.result.hasResource { (request: TripRequest) in
            
            ScrollView {
                
                LazyVStack(spacing: 20) {
                    
                    ForEach(request.itinerary.safeRoutes) { route in
                        
                        row(route: route)
                        
                    }
                    
                }
                .padding()
                
            }
            
        }
        
    }
    
    @ViewBuilder
    private func errorState() -> some View {
        
        viewModel.result.hasError { (error: Error) in
            
            Text(error.localizedDescription)
            
//            if let error = viewModel.error {
//                Text(error.underlyingError?.localizedDescription ?? "")
//
//                if let underlyingError = error.underlyingError, let decodingError = underlyingError as? DecodingError {
//                    Text(decodingError.recoverySuggestion ?? "")
//                    Text(decodingError.failureReason ?? "")
//                    Text(decodingError.errorDescription ?? "")
//                }
//            }
            
        }
        
    }
    
    @ViewBuilder
    private func row(route: ITDRoute) -> some View {
        
        TripRouteOverview(route: route)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        
    }
    
}

public struct TripRouteOverview: View {
    
    public let route: ITDRoute
    
    public init(route: ITDRoute) {
        self.route = route
    }
    
    public var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                if let startDate = route.startDate, let endDate = route.endDate {
                    
                    Text(Self.shortIntervalFormatter.string(from: startDate, to: endDate))
                    
                }
                
                Text("\(route.publicDuration)")
                
                Spacer()
                
                Text("Umst. \(route.numberOfChanges)")
                
            }
            
            VStack {
                
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
            
        }
        
    }
    
    public static let shortIntervalFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
}


struct TripSearchResultsScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        let service = DefaultTransitService(loader: DefaultTransitService.defaultLoader())
        let viewModel = TripSearchViewModel(
            transitService: service,
            originID: 20036308,
            destinationID: 20016032
        )
        
        TripSearchScreen(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}
