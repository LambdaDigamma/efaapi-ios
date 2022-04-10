//
//  TripConfigurationSheet.swift
//  
//
//  Created by Lennart Fischer on 08.04.22.
//

import SwiftUI
import EFAAPI

public struct TripConfigurationSheet: View {
    
    @State var timeMode: TripDateTimeType = .departure
    @State var searchDate: Date = Date()
    
    @Environment(\.accent) var accentColor
    
    public var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Zeitpunkt")) {
                    
                    Picker(selection: $timeMode) {
                        ForEach(TripDateTimeType.allCases, id: \.self) { mode in
                            Text(mode.name)
                                .tag(mode)
                        }
                    } label: {
                        Text("fjsdf")
                    }
                    .foregroundColor(.white)
                    .pickerStyle(.segmented)
                    
                    DatePicker("Abfahrtszeit", selection: $searchDate)
                        .labelsHidden()
                }
                
            }
            
//            ScrollView {
                
                
                
                
                
                
//                LazyVStack {
//
//                    Divider()
//
//                    if #available(iOS 15.0, *) {
//
//                        DatePicker(selection: $searchDate, displayedComponents: [.date, .hourAndMinute]) {
//
//                            Picker(selection: $timeMode) {
//                                ForEach(TripConfigurationTimeMode.allCases, id: \.self) { mode in
//                                    Text(mode.name)
//                                        .tag(mode)
//                                }
//                            } label: {
//                                Text("fjsdf")
//                            }
//                            .foregroundColor(.white)
//                            .pickerStyle(.segmented)
//
//                        }
//
//                        DatePicker("Abfahrtszeit", selection: $searchDate)
//                            .datePickerStyle(.automatic)
//                            .accentColor(accentColor)
//                            .tint(accentColor)
//                    }
//
//                    Divider()
//
//                }
//                .padding()
                
//            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Suchoptionen ändern")
            
        }
        
    }
    
}

struct TripConfigurationSheet_Previews: PreviewProvider {
    static var previews: some View {
        
        TripConfigurationSheet()
            .efaAccentColor(.yellow)
            .preferredColorScheme(.dark)
        
    }
}
