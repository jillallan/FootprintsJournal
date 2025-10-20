//
//  Date+Extension.swift
//  FootprintsJournal
//
//  Created by Jill Allan on 12/09/2025.
//

import Foundation
import Playgrounds

extension Date {
    
    var weekOfMonth: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.component(.weekOfMonth, from: self)
    }
    
    var weekday: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let systemWeekday = calendar.component(.weekday, from: self)
        return systemWeekday == 1 ? 7 : systemWeekday - 1
    }
    
    var id: String {
        String(self.timeIntervalSinceReferenceDate)
    }
}

#Playground {
    let weekOfMonth = Date().weekOfMonth
    let weekday = Date().weekday
}


