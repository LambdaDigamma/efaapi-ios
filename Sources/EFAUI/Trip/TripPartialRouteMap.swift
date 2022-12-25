//
//  SwiftUIView.swift
//  
//
//  Created by Lennart Fischer on 16.12.22.
//

import SwiftUI
import MapKit

struct TripPartialRouteMap: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var center: CLLocationCoordinate2D
    
    func makeUIView(
        context: UIViewRepresentableContext<TripPartialRouteMap>
    ) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<TripPartialRouteMap>) {
//        uiView.setCenter(center, animated: true)
        uiView.userTrackingMode = .followWithHeading
        uiView.showsUserLocation = true
        
        var locations = [
            CLLocation(latitude: 32.7767, longitude: -96.7970),         /* San Francisco, CA */
            CLLocation(latitude: 37.7833, longitude: -122.4167),        /* Dallas, TX */
            CLLocation(latitude: 42.2814, longitude: -83.7483),         /* Ann Arbor, MI */
            CLLocation(latitude: 32.7767, longitude: -96.7970)          /* San Francisco, CA */
        ]
        
        var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        
        var polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        uiView.addOverlay(polyline)
        
    }
    
    func makeCoordinator() -> TripPartialRouteMap.Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        private let mapView: TripPartialRouteMap
        
        init(_ mapView: TripPartialRouteMap) {
            self.mapView = mapView
            
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.mapView.center = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
            
            if (overlay is MKPolyline) {
                var pr = MKPolylineRenderer(overlay: overlay)
                pr.strokeColor = UIColor.red.withAlphaComponent(0.5)
                pr.lineWidth = 5
                return pr
            }
          
            return MKOverlayRenderer()
        }
        
    }
    
}

struct TripPartialRouteMap_Previews: PreviewProvider {
    static var previews: some View {
        TripPartialRouteMap(center: .constant(.init(latitude: 40.0, longitude: 50.2)))
    }
}
