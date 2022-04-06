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
                
                VStack(spacing: 8) {
                    
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
            
            HStack(alignment: .top) {
                
                VStack {
                    
                    if let startDate = route.targetStartDate, let endDate = route.targetEndDate {
                        Text(Self.shortIntervalFormatter.string(from: startDate, to: endDate))
                    }
                    
                    if let startDate = route.realtimeStartDate, let endDate = route.realtimeEndDate {
                        Text(Self.shortIntervalFormatter.string(from: startDate, to: endDate))
                            .foregroundColor(.green)
                    }
                    
                }
                .font(.caption)
                
                Text("\(route.publicDuration)")
                
                Spacer()
                
                Text("Umst. \(route.numberOfChanges)")
                
            }
            .font(.caption)
            
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
                            
                        } else {
                            
                            HStack {
                                TransportIcon.pedestrian()
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
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
            originID: "20036308",
            destinationID: "20016032"
        )
        
        TripSearchScreen(viewModel: viewModel)
            .preferredColorScheme(.dark)
    }
}
