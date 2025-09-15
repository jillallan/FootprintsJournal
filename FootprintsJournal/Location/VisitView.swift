//
//  VisitView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 11/09/2025.
//

import SwiftData
import SwiftUI

struct VisitView: View {
    @Environment(LocationService.self) private var locationService
    @Query private var visits: [Visit]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(visits) { visit in
                    VisitRow(visit: visit)
                }
            }
            .navigationTitle("Visits")
        }
    }
}

#Preview {
    VisitView()
}
