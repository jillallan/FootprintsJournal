//
//  VisitRow.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 22/09/2025.
//

import GeoToolbox
import MapKit
import SwiftUI

struct VisitRow: View {
    let visit: Visit
    let mapItemService = MapItemService()
    @State var mapItem: MKMapItem?
    @State var placeDescriptor: PlaceDescriptor?
//    @State var title: String = "Untitled Location"
    @State var placeOfInterest: String = "Unknown place of interest"
    @State var address: String = "Unknown address"
    @State var position: MapCameraPosition = .automatic
    
    private var title: Text {
        Text("\(placeOfInterest): \(address)")
    }
    
    // Inside VisitRow (or anywhere you have access to `visit`)
    private var dateRangeText: Text {
        let arrival = visit.arrivalDate
        // Adjust this if your Visit.departureDate is non-optional
        guard let departure = visit.departureDate else {
            // Only arrival known
            return Text("\(arrival, format: .dateTime.month(.wide).day().year()) \(arrival, format: .dateTime.hour().minute())")
        }
        
        let cal = Calendar.current
        let sameDay = cal.isDate(arrival, inSameDayAs: departure)
        
        if sameDay {
            // Example: "September 23, 2025 9:05 AM – 11:20 AM"
            return Text("\(arrival, format: .dateTime.month(.wide).day().year()) \(arrival, format: .dateTime.hour().minute()) – \(departure, format: .dateTime.hour().minute())")
        } else {
            // Example: "September 23, 2025 9:05 AM – September 24, 2025 7:40 AM"
            return Text("\(arrival, format: .dateTime.month(.wide).day().year().hour().minute()) – \(departure, format: .dateTime.month(.wide).day().year().hour().minute())")
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                title
                    .font(.headline)
                
                dateRangeText
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Text(
                    "Lat: \(String(format: "%.5f", visit.latitude)), Lng: \(String(format: "%.5f", visit.longitude))"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            if let mapItem {
                VStack {
                    Map(initialPosition: position) {
                        Marker(item: mapItem)
                    }
                }
                .frame(width: 100, height: 100)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "map")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.accentColor.opacity(0.5))
                    )
                    .frame(width: 100, height: 100)
            }
        }
        .task {
            guard let addressName = await mapItemService
                .getAddress(for: visit.location)?.name else {
                return
            }
            address = addressName
            guard let placeOfInterestName = await mapItemService
                .getPlaceOfInterest(for: visit.location)?.name else {
                return
            }
            placeOfInterest = placeOfInterestName
        
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    List {
        VisitRow(visit: Visit.day1[0])
    }
    
}
