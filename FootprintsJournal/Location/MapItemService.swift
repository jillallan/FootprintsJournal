//
//  MapItemService.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 18/09/2025.
//

import CoreLocation
import Foundation
import MapKit
import OSLog

@MainActor
struct MapItemService {
    static var logger = Logger(
        subsystem: "FootprintsJournal",
        category: String(describing: MapItemService.self)
    )
    
    func getLocationDetails(
        for location: CLLocation
    ) async -> MKMapItem? {
        // TODO: -
        
//
        

        
        if let POI = await getPlaceOfInterest(for: location),
            let address = await getAddress(for: location) {
            
            let POIDistance = POI.location.distance(from: location)
            let addressDistance = address.location.distance(from: location)
//            print("  --- COMPARING LOCATIONS ---")
//            
//            print(
//                """
//                timestamp: \(location.timestamp): 
//                    speed: \(location.speed)
//                    POI \(POI.name ?? "unknown") distance: \(POIDistance) 
//                    address \(address.name ?? "unknown") distance: \(addressDistance)
//                """
//            )
            
            return addressDistance < POIDistance ? address : POI
        } else {
            return nil
        }

        
        // If stationary check if at home or work
        // then check if at a contacts location
        // check both place of interest and address
        // If moving at walking speed check both place of interest and address
        // if moving above walking speed get address
        
    }
    
    
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
        
//        print("[POI] Request: center=(\(coordinate.latitude), \(coordinate.longitude)), radius=\(radius)")
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
            let filtered = response.mapItems  // .filter { item in
//                guard let category = item.pointOfInterestCategory else { return false } // drop nil categories
//                return !excluded.contains(category)
        
//            }
            
//            print("  -- PRINTING MAP ITEMS --")
//            _ = filtered.map { item in
//                print("""
//                [POI] Nearby: \(item.name ?? "(no name)")
//                      speed: \(location.speed)
//                      category: \(item.pointOfInterestCategory?.rawValue ?? "NA")
//                      distance: \(location.distance(from: CLLocation(latitude: item.location.coordinate.latitude, longitude: item.location.coordinate.longitude))) m
//                """)
//            }
            
            if let first = filtered.first {
                print("[POI] Found: \(first.name ?? "(no name)")")
//                self.mapItem = first
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
//                print(
//                    """
//                    name: \(String(describing: fetchedMapItem.name))
//                    fetched map item: \(String(describing: fetchedMapItem.address))
//                    speed: \(location.speed)
//                    """
//                )
                return fetchedMapItem
                
                
            } catch {
                print("Reverse geocoding failed: \(error)")
                return nil
            }
        }
        return nil
    }
}
