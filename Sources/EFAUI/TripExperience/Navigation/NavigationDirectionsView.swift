//
//  NavigationDirectionsView.swift
//  
//
//  Created by Lennart Fischer on 25.12.22.
//

import UIKit
import SwiftUI
import MapKit
import Core

public struct NavigationDirectionsData {
    
    public let source: Point
    public let destination: Point
    
    public init(source: Point, destination: Point) {
        self.source = source
        self.destination = destination
    }
    
}

//public struct NavigationDirections: View {
//
//    @StateObject public var viewModel: NavigationViewModel
//
//    public init(data: NavigationDirectionsData) {
//        self._viewModel = StateObject(
//            wrappedValue: NavigationViewModel(source: data.source, destination: data.destination)
//        )
//    }
//
//    public var body: some View {
//
//
//
//    }
//
//
//}

public struct NavigationDirectionsView: UIViewRepresentable {
    
    public typealias UIViewType = MKMapView
    
    @StateObject public var viewModel: NavigationViewModel
    
    public init(data: NavigationDirectionsData) {
        self._viewModel = StateObject(
            wrappedValue: NavigationViewModel(source: data.source, destination: data.destination)
        )
    }
    
    public func makeUIView(
        context: UIViewRepresentableContext<NavigationDirectionsView>
    ) -> MKMapView {
        
        let mapView = MKMapView()
        mapView.tintColor = UIColor(Color.routeLine)
        mapView.delegate = context.coordinator
        
        Task {
            await viewModel.load()
            self.addDirection(mapView: mapView)
        }
        
        return mapView
    }
    
    public func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<NavigationDirectionsView>) {
        
        uiView.showsUserLocation = true
        uiView.setUserTrackingMode(.followWithHeading, animated: true)
        
    }
    
    public func makeCoordinator() -> NavigationDirectionsView.Coordinator {
        Coordinator(self)
    }
    
    public final class Coordinator: NSObject, MKMapViewDelegate {
        
        private let mapView: NavigationDirectionsView
        
//        public let navigationService = DefaultNavigationService()
        
        public init(_ mapView: NavigationDirectionsView) {
            
            self.mapView = mapView
            
        }
        
        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            if (overlay is MKPolyline) {
                let pr = MKPolylineRenderer(overlay: overlay)
                pr.strokeColor = UIColor(Color.routeLine)
                pr.lineWidth = 7
                return pr
            }
            
            return MKOverlayRenderer()
        }
        
    }
    
    // MARK: - Annotations -
    
    private func addDirection(mapView: MKMapView) {
        
        guard let directions = viewModel.directions.value else { return }
        
        if let firstRoute = directions.routes.first {
            
//            firstRoute.polyline.points().
            
            let region = MKCoordinateRegion(
                center: firstRoute.polyline.coordinate,
                latitudinalMeters: 150,
                longitudinalMeters: 150
            )
            
            mapView.setRegion(region, animated: true)
            mapView.addOverlay(firstRoute.polyline)
        }
        
    }
    
}

struct NavigationDirectionsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationDirectionsView(data: .init(
            source: Point(latitude: 51.45208, longitude: 6.62323),
            destination: Point(latitude: 51.45081, longitude: 6.64163)
        ))
    }
    
}
