//
//  SwiftUIView.swift
//  
//
//  Created by Lennart Fischer on 16.12.22.
//

import SwiftUI
import Combine
import CoreLocation
import Core
import Factory

public class InTrainMapViewModel: ObservableObject {
    
    @Published public var currentSpeed: String?
    @Published public var currentPlace: String?
    
    @Injected(Container.geocodingService) var geocodingService
    
    private let locationObject = CoreLocationObject()
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        
    }
    
    public func start() {
        
        let location = locationObject
            .$location
            .share()
        
        location
            .receive(on: DispatchQueue.main)
            .sink { (location: CLLocation?) in
                
                if let accuracy = location?.speedAccuracy, let speed = location?.speed, speed > 0 {
                    
                    if #available(iOS 15.0, *) {
                        
                        let measurement = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
                        self.currentSpeed = "\(measurement.converted(to: .kilometersPerHour).formatted())"
                    }
                    
                }
                
            }
            .store(in: &cancellables)
        
        locationObject.beginUpdates(.authorizedWhenInUse)
        
        let timerPublisher = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
            
        let geocoded = timerPublisher
            .setFailureType(to: Error.self)
            .flatMap { output in
                
                if let location = self.locationObject.location {
                    return self.geocodingService.placemark(from: location).eraseToAnyPublisher()
                } else {
                    return Fail<CLPlacemark, Error>(error: APIError.noData)
                        .eraseToAnyPublisher()
                }
                
            }
            .eraseToAnyPublisher()
        
        geocoded
            .map(\.city)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink { (completion: Subscribers.Completion<Error>) in
                
            } receiveValue: { (city: String) in
                self.currentPlace = city
            }
            .store(in: &cancellables)
            
    }
    
    public func stop() {
        
        locationObject.endUpdates()
        
    }
    
}

struct InTrainMap: View {
    
    public let accent: Color = .yellow // .init(hex: "E16335")
    public let onAccent: Color = .black
    
    @StateObject var viewModel: InTrainMapViewModel = .init()
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            HStack(alignment: .top) {
                
                if let place = viewModel.currentPlace {
                    
                    Pill(
                        text: Text("\(Image(systemName: "location.fill")) \(place)"),
                        background: accent
                    )
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(onAccent)
                    .offset(x: 0, y: 6)
                    
                }
                
                Spacer()
                
                if let speed = viewModel.currentSpeed {
                    
                    if #available(iOS 15.0, *) {
                        Pill(
                            text: Text("\(Image(systemName: "speedometer")) \(speed)"),
                            background: accent
                        )
                        .monospacedDigit()
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(onAccent)
                        .offset(x: 0, y: 6)
                    } else {
                        Pill(
                            text: Text("\(Image(systemName: "speedometer")) \(speed)"),
                            background: accent
                        )
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(onAccent)
                        .offset(x: 0, y: 6)
                    }
                    
                }
                
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
                
                TripPartialRouteMap(center: .constant(.init(latitude: 40.0, longitude: 50.2)))
                    .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                
                
//                MapSnapshotView(
//                    location: CLLocationCoordinate2D(
//                        latitude: 51,
//                        longitude: 26
//                    ),
//                    span: 0.5
//                )
//                .aspectRatio(CGSize(width: 16, height: 9), contentMode: .fit)
                
                NextStops()
                
            }
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(12)
            
        }
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        
    }
    
}

struct InTrainMap_Previews: PreviewProvider {
    static var previews: some View {
        InTrainMap()
            .padding()
            .preferredColorScheme(.dark)
    }
}
