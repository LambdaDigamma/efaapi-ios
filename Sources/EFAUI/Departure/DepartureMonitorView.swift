//
//  DepartureMonitorView.swift
//  
//
//  Created by Lennart Fischer on 08.12.21.
//

import SwiftUI
import WidgetKit
import EFAAPI

struct DepartureMonitorView: View {
    
    var viewModel: DepartureMonitorViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    static let taskDateFormat: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = .standalone
        formatter.unitsStyle = .abbreviated
        formatter.dateTimeStyle = .numeric
        return formatter
    }()
    
    var cardBackgroundColor: Color {
        if colorScheme == .light {
            return Color.white
        } else {
            return Color.black
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Duisburg Hbf")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 4) {
                
                let departures = viewModel.departures.prefix(3)
                
                ForEach(departures) { departure in
                    
                    DepartureRowView(departure: departure)
                    
                }
                
            }
            
            Spacer()
                .frame(maxHeight: 20)
            
            HStack {
                
//                    Text("nur ICE 22 & RE 5")
//                        .layoutPriority(100)
//                    Spacer()
//                        .frame(maxWidth: .infinity)
//                        .layoutPriority(50)
                
                HStack {
                    Text("zuletzt aktualisiert: ") +
                    Text(viewModel.date, style: .relative)
                }
                .layoutPriority(100)
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundColor(.secondary)
            .font(.system(size: 8, weight: .regular, design: .default))
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(cardBackgroundColor)
        
    }
    
}

struct DepartureMonitorView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let viewModel = DepartureMonitorViewModel(
            stationName: "Duisburg Hbf",
            departures: [
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.actualDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 2)))
                        .setting(\.servingLine.direction, to: "Münster (Westf) Hbf")
                        .setting(\.servingLine.symbol, to: "S1")
                ),
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.regularDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 5)))
                        .setting(\.servingLine.direction, to: "Dortmund Hbf")
                        .setting(\.servingLine.symbol, to: "ICE 933")
                ),
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.regularDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 10)))
                        .setting(\.servingLine.direction, to: "Rheurdt Kirche")
                        .setting(\.servingLine.symbol, to: "SB 30")
                        .setting(\.platformName, to: "1")
                ),
                DepartureViewModel(
                    departure: ITDDeparture.stub()
                        .setting(\.regularDateTime,
                                  to: ITDDateTime.stub(date: .init(timeIntervalSinceNow: 60 * 20)))
                        .setting(\.servingLine.direction, to: "Duisburg Ruhrau")
                        .setting(\.servingLine.symbol, to: "RE 1")
                )
            ],
            date: Date(timeIntervalSinceNow: -60 * 8)
        )
        
        DepartureMonitorView(viewModel: viewModel)
            .environment(\.locale, Locale(identifier: "de"))
            .previewLayout(.sizeThatFits)
        
        DepartureMonitorView(viewModel: viewModel)
            .environment(\.locale, Locale(identifier: "de"))
            .environment(\.colorScheme, .dark)
            .previewLayout(.sizeThatFits)
        
    }
    
}