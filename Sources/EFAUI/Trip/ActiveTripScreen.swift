//
//  ActiveTripScreen.swift
//  
//
//  Created by Lennart Fischer on 03.04.22.
//

import SwiftUI
import CoreLocation
import Combine
import Core

public class TripViewModel: ObservableObject {
    
    private let cancellables = Set<AnyCancellable>()
    
    public init() {
        
    }
    
    public func terminate() {
        
    }
    
//    public
    
}


public struct ActiveTripScreen: View {
    
    public let origin: String
    public let destination: String
    
    public let plannedDeparture: Date = Date(timeIntervalSinceNow: 60 * 5)
    public let realtimeDeparture: Date = Date(timeIntervalSinceNow: 60 * 9)
    
    public let plannedArrival: Date = Date(timeIntervalSinceNow: 60 * 60)
    public let realtimeArrival: Date = Date(timeIntervalSinceNow: 60 * 63)
    
    public let isBoardedTrain = true
    
    public let track: String = "11"
    
    public let accent: Color = .yellow // .init(hex: "E16335")
    public let onAccent: Color = .black
    
    public var body: some View {
        
        NavigationDirectionsView(data: .init(
            source: Point(latitude: 51.45208, longitude: 6.62323),
            destination: Point(latitude: 51.45081, longitude: 6.64163)
        ))
//        .frame(maxWidth: .infinity, minHeight: 500, maxHeight: 500)
        
//        ScrollView {
//
//            LazyVStack {
//
//                top()
//                    .padding(.bottom, 60)
//
//                if !isBoardedTrain {
//                    trackView()
//                        .padding(.bottom, 80)
//                } else {
//                    inTrain()
//                        .padding()
//                        .padding(.bottom, 40)
//                }
//
//                timeInformation()
//
//                Divider()
//                    .padding()
//
//                actions()
//
//            }
//            .padding(.top)
//
//        }
//        .background(
//            LinearGradient(colors: [
//                Color(hex: "13151A"),
//                Color(hex: "1C1E23")
//            ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
//        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                Button(action: {}) {
                    Image(systemName: "arrow.triangle.branch")
                        .foregroundColor(accent)
                }
                
                Menu {
                    Button(action: {}) {
                        Text("Beenden")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(accent)
                }
                
//                Button(action: {}) {
//                    Image(systemName: "ellipsis.circle")
//                }
//                .foregroundColor(accent)
            }
        }
        .toolbar {
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(""))
        
    }
    
    @ViewBuilder
    private func top() -> some View {
        
        VStack(spacing: 12) {
            
            Text("\(origin) \(Image(systemName: "arrow.right")) \(destination)")
                .fontWeight(.semibold)
            
            HStack(spacing: 20) {
                
                Text("\(Image(systemName: "tram.fill")) RE5")
                
                Text("\(Image(systemName: "wifi")) WI-FI")
                
            }
            .font(.callout.weight(.semibold))
            .foregroundColor(.secondary)
            
        }
        
    }
    
    @ViewBuilder
    private func trackView() -> some View {
        
        BigTrackBadge(track: "11", accent: accent, onAccent: onAccent)
        
    }
    
    @ViewBuilder
    private func inTrain() -> some View {
        
        InTrainMap()
        
    }
    
    @ViewBuilder
    private func timeInformation() -> some View {
        
        TimeInformation(
            accentColor: accent,
            onAccent: onAccent,
            plannedDeparture: plannedDeparture,
            realtimeDeparture: realtimeDeparture,
            plannedArrival: plannedArrival,
            realtimeArrival: realtimeArrival,
            isBoardedTrain: isBoardedTrain
        )
        .padding()
        
    }
    
    @ViewBuilder
    private func actions() -> some View {
        
        if !isBoardedTrain {
            Button(action: {}) {
                Text(PackageStrings.ActiveTrip.checkIntoTrain)
                    .foregroundColor(accent)
            }
        }
        
    }
    
}

struct ActiveTripScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActiveTripScreen(
                origin: "Duisburg, Hbf",
                destination: "Aachen, Hbf"
            )
        }.preferredColorScheme(.dark)
    }
}
