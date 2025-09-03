//
//  SampleData+Entry.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 03/09/2025.
//

import Foundation
import SwiftData

extension Entry {
    static let sample1 = Entry(
        title: "A Walk in the Park",
        content: "Enjoyed a peaceful morning walk and saw some beautiful flowers.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 5)
    )
    static let sample2 = Entry(
        title: "Rainy Day Thoughts",
        content: "Stayed indoors, read a book, and listened to the rain tapping on the windows.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 3)
    )
    static let sample3 = Entry(
        title: "Coffee with a Friend",
        content: "Met up with Alex at our favorite café. Had a great catch-up session!",
        timestamp: Date(timeIntervalSinceNow: -86400 * 2)
    )
    static let sample4 = Entry(
        title: "Productive Work Session",
        content: "Managed to focus and finish all my tasks for the day ahead of schedule.",
        timestamp: Date(timeIntervalSinceNow: -86400)
    )
    static let sample5 = Entry(
        title: "Sunset Reflections",
        content: "Watched the sunset by the lake—such a calming end to a busy day.",
        timestamp: Date()
    )
    
    static func insertSampleData(modelContext: ModelContext) {
        modelContext.insert(sample1)
        modelContext.insert(sample2)
        modelContext.insert(sample3)
        modelContext.insert(sample4)
        modelContext.insert(sample5)
    }
    
    static func reloadSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Entry.self)
            insertSampleData(modelContext: modelContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
