//
//  TransportTypeSymbol.swift
//  
//
//  Created by Lennart Fischer on 09.12.21.
//

import SwiftUI
import EFAAPI

struct TransportTypeSymbol: View {
    
    let transportType: TransportType
    
    var body: some View {
        
        let displayData = data(type: transportType)
        let transportImage = TransportIcon.icon(for: transportType)
        
        transportImage
            .padding(8)
            .foregroundColor(displayData.foreground)
            .background(Circle()
                            .fill(displayData.background))
            .accessibility(label: Text(transportType.localizedName))
        
    }
    
    func data(type: TransportType) -> (background: Color, foreground: Color) {
        
        switch type {
            case .rapidBus, .cityBus, .regionalBus, .communityBus, .onCallBus:
                return (Color.green, Color.white)
            case .train, .internationalTrain, .shuttleTrain, .regionalTrain, .nationalTrain, .highSpeedTrain:
                return (Color.red, Color.white)
            case .metro, .suburbanRailway, .tram:
                return (Color.green, Color.white)
            case .subway:
                return (Color.blue, Color.white)
            case .plane:
                return (Color.black, Color.white)
            default:
                return (Color.black, Color.white)
        }
        
    }
    
}

struct TransportTypeSymbol_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let cases = TransportType.allCases
        
        VStack(alignment: .leading) {
            
            ForEach(cases, id: \.self) { t in
                
                HStack(spacing: 16) {
                    TransportTypeSymbol(transportType: t)
                    Text("Duisburg")
                }
                .padding()
                
            }
            
        }.previewLayout(.sizeThatFits)
        
    }
    
}
