//
//  LocationRowView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import MapKit
import SwiftUI

struct LocationRowView: View {
    let location: Location
    @State var mapItem: MKMapItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Placeholder Title
            Text("Untitled Location")
                .font(.largeTitle)
                .fontWeight(.bold)
            // Date & Time
            Text(location.timestamp, format: Date.FormatStyle(date: .long, time: .shortened))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            // Coordinates subtitle
            Text("Lat: \(String(format: "%.5f", location.latitude)), Lng: \(String(format: "%.5f", location.longitude))")
                .font(.caption)
                .foregroundStyle(.secondary)
            // Map placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "map")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor.opacity(0.5))
                )
                .frame(height: 120)
        }
        .padding()
        .task {
            if let request = MKReverseGeocodingRequest(
                location: location.location
            ) {
                let mapItems = try await request.mapItems
                if let fetchedMapItem = mapItems.first {
                    mapItem = mapItem
                }
            }
        }
    }
    
}

#Preview(traits: .modifier(SampleData())) {
    LocationRowView(location: .preview)
}
