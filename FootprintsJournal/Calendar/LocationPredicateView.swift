//
//  LocationPredicateView.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 19/09/2025.
//

import SwiftData
import SwiftUI

struct LocationPredicateView: View {
    @Query(sort: \Location.timestamp) private var locations: [Location]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LocationPredicateView()
}
