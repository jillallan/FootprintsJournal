//
//  SampleData.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import Foundation
import SwiftData
import SwiftUI

struct SampleData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        // Initialize a schema with your model types. Add more types here if needed.
        let schema = Schema([Entry.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])

        // Insert sample data on the main actor so previews see it immediately.
        await MainActor.run {
            Entry.insertSampleData(modelContext: container.mainContext)
        }

        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}
