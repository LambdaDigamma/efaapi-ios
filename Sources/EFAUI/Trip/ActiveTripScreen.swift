//
//  ActiveTripScreen.swift
//  
//
//  Created by Lennart Fischer on 03.04.22.
//

import SwiftUI
import CoreLocation
import Combine

public class TripViewModel: ObservableObject {
    
    private let cancellables = Set<AnyCancellable>()
    
    public init() {
        
    }
    
    public func terminate() {
        
    }
    
//    public
    
}


struct ActiveTripScreen: View {
    
    public let origin: String
    public let destination: String
    
    public let plannedDeparture: Date = Date(timeIntervalSinceNow: 60 * 5)
    public let realtimeDeparture: Date = Date(timeIntervalSinceNow: 60 * 9)
    
    public let plannedArrival: Date = Date(timeIntervalSinceNow: 60 * 60)
    public let realtimeArrival: Date = Date(timeIntervalSinceNow: 60 * 63)
    
    public let isBoardedTrain = true
    
    public let track: String = "11"
    
    public let accent: Color = .init(hex: "E16335")
    public let onAccent: Color = .white
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                top()
                    .padding(.bottom, 60)
                
                if !isBoardedTrain {
                    trackView()
                        .padding(.bottom, 80)
                } else {
                    inTrain()
                        .padding()
                        .padding(.bottom, 40)
                }
                
                timeInformation()
                
                Divider()
                    .padding()
                
                actions()
                
            }
            .padding(.top)
            
        }
//        .background(
//            LinearGradient(colors: [
//                Color(hex: "13151A"),
//                Color(hex: "1C1E23")
//            ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
//        )
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
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
        
        ZStack(alignment: .topTrailing) {
            
            HStack(alignment: .top) {
                
                Pill(text: Text("\(Image(systemName: "location.fill")) Moers"), background: accent)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(onAccent)
                    .offset(x: 0, y: 6)
                
                Spacer()
                
                Pill(text: Text("\(Image(systemName: "speedometer")) 134km/h"), background: accent)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(onAccent)
                    .offset(x: 0, y: 6)
                
//                BigTrackBadge(
//                    track: "11",
//                    accent: accent,
//                    onAccent: onAccent
//                )
//                .shadow(color: accent.opacity(0.5), radius: 6)
                
            }
            .zIndex(20)
            .padding(.horizontal)
            .offset(x: 0, y: -20)
            
            
            VStack(spacing: 0) {
                
                MapSnapshotView(
                    location: CLLocationCoordinate2D(
                        latitude: 51,
                        longitude: 26
                    ),
                    span: 0.5
                )
                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                
                NextStops()
                
            }
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(12)
            
        }
        
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

public struct BigTrackBadge: View {
    
    public let track: String
    public let accent: Color
    public let onAccent: Color
    
    public init(
        track: String,
        accent: Color,
        onAccent: Color
    ) {
        self.track = track
        self.accent = accent
        self.onAccent = onAccent
    }
    
    public var body: some View {
        
        VStack {
            
            Text("Gleis".uppercased())
                .font(.caption)
                .fontWeight(.semibold)
//                .tracking(1)
            
            Text(track)
                .font(.largeTitle)
                .fontWeight(.heavy)
            
        }
        .foregroundColor(onAccent)
        .padding(.horizontal, 24)
        .padding(.vertical, 8)
        .background(accent)
        .cornerRadius(8)
        
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
