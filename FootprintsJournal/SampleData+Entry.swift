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
        content: "Enjoyed a peaceful morning walk and saw some beautiful flowers. The air was crisp and fresh, the sound of birdsong all around. I took my time, letting each step ground me and clear my mind from the busyness of the week.\n\nAs I wandered along the path, I noticed new blooms that hadn't been there before—bright yellows and deep purples standing out against the greenery. Sitting for a while on a shaded bench, I watched the sunlight play on the leaves, feeling grateful for such simple moments.\n\nBy the time I left the park, I felt lighter and more connected to the world around me. These quiet walks always remind me how restorative nature can be.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 5)
    )
    static let sample2 = Entry(
        title: "Rainy Day Thoughts",
        content: "Stayed indoors, read a book, and listened to the rain tapping on the windows. The steady rhythm outside was soothing, and I found myself lost in the pages for hours, letting the story carry me away from daily worries.\n\nOccasionally, I would pause to make a cup of tea, watching droplets race down the glass. The world felt quieter and more introspective on a day like this, urging me to slow down, reflect, and appreciate the warmth and comfort of home.\n\nAs evening settled in, the rain continued, a gentle soundtrack for unwinding and drifting into restful sleep.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 3)
    )
    static let sample3 = Entry(
        title: "Coffee with a Friend",
        content: "Met up with Alex at our favorite café. Had a great catch-up session! The familiar hum of conversation and clinking cups created the perfect backdrop for our laughter and stories.\n\nWe talked about work, travels, and future plans, reminiscing about old adventures and dreaming up new ones. The time flew by as we bounced between lighthearted jokes and deeper conversations about life changes and personal growth.\n\nLeaving the café, I felt recharged and grateful for friendships that stand the test of time. These meetups always remind me of the importance of staying connected, even when life gets busy.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 2)
    )
    static let sample4 = Entry(
        title: "Productive Work Session",
        content: "Managed to focus and finish all my tasks for the day ahead of schedule. I started the morning with a clear list and set small goals to tackle one at a time, which made the workload feel less overwhelming.\n\nWith some calming music in the background, I found my flow and checked off each item with a sense of accomplishment. It was satisfying to see progress and realize how much I could get done with a focused mindset.\n\nBy mid-afternoon, my desk was clear and my mind was at ease. The early finish gave me space to relax and enjoy the rest of the day without any lingering stress.",
        timestamp: Date(timeIntervalSinceNow: -86400)
    )
    static let sample5 = Entry(
        title: "Sunset Reflections",
        content: "Watched the sunset by the lake—such a calming end to a busy day. The sky transformed into a canvas of oranges, pinks, and purples, reflecting off the still water as the world slowly quieted down.\n\nSitting on the shore, I let my thoughts wander and reflected on the day's events, both the challenges and the small victories. The cool breeze, gentle waves, and fading light created a sense of peace that I rarely experience elsewhere.\n\nBy the time the last rays disappeared, I felt grounded and ready for whatever tomorrow brings. Nature's beauty is always the perfect reminder to pause and be present.",
        timestamp: Date()
    )
    static let sample6 = Entry(
        title: "Stargazing Night",
        content: "Spent the evening lying on the grass, watching the stars appear as dusk faded. The sky was clear, and I could make out several constellations. It felt magical to just be still, breathing in the cool night air, and feeling the vastness of the universe overhead. A shooting star streaked by, and I made a quiet wish.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 6)
    )
    static let sample7 = Entry(
        title: "Baking Experiment",
        content: "Tried baking a new type of bread today. The kitchen was filled with the comforting scent of yeast and flour. Although the loaf wasn't perfect, it was fun trying something new, kneading the dough by hand, and sharing the end result with family. Next time, I'll try adding seeds or spices.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 7)
    )
    static let sample8 = Entry(
        title: "A Day at the Museum",
        content: "Visited the local art museum and wandered through the quiet galleries. Each painting told its own story, and I found myself lost in the colors and details. Took a sketchbook along and tried to capture a few sculptures in quick pencil lines. Left feeling inspired and full of new ideas.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 8)
    )
    static let sample9 = Entry(
        title: "Sunday Brunch",
        content: "Had brunch with family at a new place downtown. The food was delicious, and the sun poured in through big windows. Laughter and good conversation made for the perfect start to the week. Snapped a few photos to remember the morning by.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 9)
    )
    static let sample10 = Entry(
        title: "Quiet Library Afternoon",
        content: "Spent a few hours at the library, browsing the shelves for new reads. Found a cozy corner and got lost in a novel. The peaceful atmosphere and soft rustling of pages were the perfect escape from a busy week.",
        timestamp: Date(timeIntervalSinceNow: -86400 * 10)
    )
    
    static func insertSampleData(modelContext: ModelContext) {
        modelContext.insert(sample1)
        modelContext.insert(sample2)
        modelContext.insert(sample3)
        modelContext.insert(sample4)
        modelContext.insert(sample5)
        modelContext.insert(sample6)
        modelContext.insert(sample7)
        modelContext.insert(sample8)
        modelContext.insert(sample9)
        modelContext.insert(sample10)
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

