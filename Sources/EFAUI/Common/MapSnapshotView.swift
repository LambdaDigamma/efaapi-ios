//
//  MapSnapshotView.swift
//  
//
//  Created by Lennart Fischer on 09.12.21.
//

import SwiftUI
import MapKit

#if canImport(UIKit)

struct MapSnapshotView: View {
    
    let location: CLLocationCoordinate2D
    var span: CLLocationDegrees = 0.01
    
    @State private var snapshotImage: UIImage? = nil
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if let image = snapshotImage {
                    Image(uiImage: image)
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                }
            }
            .onAppear {
                generateSnapshot(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
    
    func generateSnapshot(width: CGFloat, height: CGFloat) {
        
        let region = MKCoordinateRegion(
            center: self.location,
            span: MKCoordinateSpan(
                latitudeDelta: self.span,
                longitudeDelta: self.span
            )
        )
        
        let mapOptions = MKMapSnapshotter.Options()
        mapOptions.region = region
        mapOptions.size = CGSize(width: width, height: height)
        mapOptions.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: mapOptions)
        snapshotter.start { (snapshotOrNil, errorOrNil) in
            if let error = errorOrNil {
                print(error)
                return
            }
            if let snapshot = snapshotOrNil {
                self.snapshotImage = snapshot.image
            }
        }
        
    }
    
}

struct MapSnapshotView_Previews: PreviewProvider {
    static var previews: some View {
        let coordinates = CLLocationCoordinate2D(
            latitude: 37.332077,
            longitude: -122.02962
        )
        MapSnapshotView(location: coordinates)
            .frame(maxWidth: 200, maxHeight: 200)
            .previewLayout(.sizeThatFits)
    }
}

#endif
