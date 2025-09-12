//
//  LocationView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 09/09/2025.
//

import SwiftData
import SwiftUI
import CoreLocation

struct LocationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var locations: [Location]
    
    @Environment(LocationService.self) private var locationService
    
//    @State var locationService: LocationService? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locations) { location in
                    LocationRowView(location: location)
                }
            }
            .navigationTitle("Locations")
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addLocation) {
                        Label("Add Location", systemImage: "plus")
                    }
                }
            }
//            .onAppear {
//                
//                let locationRepository = PersistenceController(
//                    modelContext: modelContext
//                )
//                locationService = LocationService(persister: locationRepository)
//            }
        }
    }
    
    private func addLocation() {
        withAnimation {
            let location = Location(
                clLocation: CLLocation(latitude: 51.5, longitude: 0.0)
            )
            modelContext.insert(location)
        }
    }
}

#Preview {
    LocationView()
        
}

