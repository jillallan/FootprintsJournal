//
//  LocationRow.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import GeoToolbox
import MapKit
import SwiftUI

struct LocationRow: View {
    let location: CLLocation
    @State var mapItem: MKMapItem?
    @State var placeDescriptor: PlaceDescriptor?
    @State var title: String = "Untitled Location"
    @State var position: MapCameraPosition = .automatic
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(location.timestamp, format: Date.FormatStyle(date: .long, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Lat: \(String(format: "%.5f", location.coordinate.latitude)), Lng: \(String(format: "%.5f", location.coordinate.longitude))")
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
                //                    .frame(height: 120)
            }
        }
        .task {
//            mapItem = await MapItemService.getLocationDetails(for: location)
//            if let mapItem {
//                position = MapCameraPosition.item(mapItem)
//                title = mapItem.name ?? "Unknown"
//            } else {
//                title = "Unknown"
//            }
        }
        
        
        //        .task {
        //            mapItem = await getAddress(for: location)
        //            if let mapItem {
        //                position = MapCameraPosition.item(mapItem)
        //                if let name = mapItem.name {
        //                    title = name
        //                }
        //            }
        //        }
//        .task {
//            mapItem = await getPlaceOfInterest(for: location)
//            if let mapItem {
//                position = MapCameraPosition.item(mapItem)
//                title = mapItem.name ?? "Unknown"
//            } else {
//                title = "Unknown"
//            }
//        }
    }
}

extension LocationRow {
    // TODO: - Move to struct
    
    
    func getPlaceOfInterest(for location: CLLocation) async -> MKMapItem? {
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        let radius = max(location.horizontalAccuracy, 75) // ensure a sensible minimum
        let pointsOfInterestRequest = MKLocalPointsOfInterestRequest(
            center: coordinate,
            radius: radius
        )
        
//        pointsOfInterestRequest.pointOfInterestFilter = MKPointOfInterestFilter(
//            excluding: [
//                .parking,
//                .bank,
//                .atm,
//                .hospital,
//                .postOffice,
//                .evCharger,
//                .park,
//                .mailbox,
//            ]
//        )
        
        print("[POI] Request: center=(\(coordinate.latitude), \(coordinate.longitude)), radius=\(radius)")
        let localSearch = MKLocalSearch(request: pointsOfInterestRequest)
        
        do {
            
            let response = try await localSearch.start()
            
            let excluded: Set<MKPointOfInterestCategory> = [
                .parking,
                .bank,
                .atm,
                .hospital,
                .postOffice,
                .evCharger,
                .park,
                .mailbox,
            ]

            // Keep only items that have a category and aren’t in the excluded set
            let filtered = response.mapItems.filter { item in
                guard let category = item.pointOfInterestCategory else { return false } // drop nil categories
                return !excluded.contains(category)
            }
            
            print("  -- PRINTING MAP ITEMS --")
            _ = filtered.map { item in
                print("""
                [POI] Nearby: \(item.name ?? "(no name)")
                      category: \(item.pointOfInterestCategory?.rawValue ?? "NA")
                      distance: \(location.distance(from: CLLocation(latitude: item.location.coordinate.latitude, longitude: item.location.coordinate.longitude))) m
                """)
            }
            
            if let first = filtered.first {
                print("[POI] Found: \(first.name ?? "(no name)")")
                self.mapItem = first
                return first
            } else {
                print("[POI] No results; falling back to reverse geocoding…")
                return await getAddress(for: location)
            }
        } catch {
            print("[POI] Search failed with error: \(error). Falling back to reverse geocoding…")
            return await getAddress(for: location)
        }
    }
    
    func getAddress(for location: CLLocation) async -> MKMapItem? {
        if let request = MKReverseGeocodingRequest(location: location) {
            do {
                let mapItems = try await request.mapItems
                guard let fetchedMapItem = mapItems.first else { return nil }
                print("fetched map item: \(fetchedMapItem)")
                return fetchedMapItem
                
                
            } catch {
                print("Reverse geocoding failed: \(error)")
                return nil
            }
        }
        return nil
    }
    
    /// Filters an ordered list of MKMapItem results by removing specific categories (parking, ev charger, post office, bank, ATM)
    /// unless they are more than 20 meters away from the next closest item in the list.
    /// - Parameter items: An array of MKMapItem assumed to be sorted by distance ascending from the request center.
    /// - Returns: A filtered array preserving original order.
    func filterPOIsRemovingCommonUtilityCategoriesUnlessFartherThanNext(_ items: [MKMapItem]) -> [MKMapItem] {
        // Categories to de-prioritize/remove unless sufficiently separated from the next closest item
        let excluded: Set<MKPointOfInterestCategory> = [
            .parking,
            .evCharger,
            .postOffice,
            .bank,
            .atm
        ]
        
        guard items.count > 1 else { return items }
        
        var result: [MKMapItem] = []
        result.reserveCapacity(items.count)
        
        for i in 0..<items.count {
            let current = items[i]
            // If current has no category, keep it
            guard let category = current.pointOfInterestCategory else {
                result.append(current)
                continue
            }
            
            // If the category is not in the excluded set, keep it
            guard excluded.contains(category) else {
                result.append(current)
                continue
            }
            
            // If it's the last item, keep it (no "next" item to compare separation)
            guard i < items.count - 1 else {
                result.append(current)
                continue
            }
            
            let next = items[i + 1]
            // Compute distance between current and next
            if let cLoc = current.placemark.location, let nLoc = next.placemark.location {
                let separation = cLoc.distance(from: nLoc)
                if separation > 20 {
                    // Keep only if sufficiently separated from the next item
                    result.append(current)
                } else {
                    // Drop this common utility category because it's too close to the next item
                    // (implicitly removed by not appending)
                }
            } else {
                // If we can't compute distance, err on the side of keeping the item
                result.append(current)
            }
        }
        
        return result
    }
}

#Preview(traits: .modifier(SampleData())) {
    let location = CLLocation(latitude: 51.5, longitude: 0.0)
    LocationRow(location: location)
}

