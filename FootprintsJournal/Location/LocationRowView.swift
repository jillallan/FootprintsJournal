//
//  LocationRowView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import GeoToolbox
import MapKit
import SwiftUI

struct LocationRowView: View {
    let location: Location
    @State var mapItem: MKMapItem?
    @State var placeDescriptor: PlaceDescriptor?
    @State var title: String = "Untitled Location"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Placeholder Title
            Text(title)
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
            
            if let mapItem {
                VStack {
                    Text(placeDescriptor?.commonName ?? "No common name")
                    Map {
                        Marker(item: mapItem)
                    }
                }
                .frame(height: 120)
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
                    .frame(height: 120)
            }
                
        }
        .padding()
        .task {
            do {
                if let request = MKReverseGeocodingRequest(
                    location: location.location
                ) {
                    let mapItems = try await request.mapItems
                    if let fetchedMapItem = mapItems.first {
                        mapItem = fetchedMapItem
                        title = fetchedMapItem.name ?? "Unknown Location"
                        guard let descriptor = PlaceDescriptor(item: fetchedMapItem) else {
                            return
                        }
                        placeDescriptor = descriptor
                        
                        let convertedMapItem = MKMapItem(
                            location: CLLocation(
                                latitude: placeDescriptor?.coordinate?.latitude ?? 0.0,
                                longitude: placeDescriptor?.coordinate?.longitude ?? 0.0
                            ),
                            address: MKAddress(
                                fullAddress: placeDescriptor?.address ?? "",
                                shortAddress: nil
                            )
                        )
                    }
                }
                
            } catch {
                // Handle the error (for now, optionally print or ignore)
                print("Reverse geocoding failed: \(error)")
            }
        }
        .task {
            
        }
    }
    
}

#Preview(traits: .modifier(SampleData())) {
    LocationRowView(location: .preview)
}
