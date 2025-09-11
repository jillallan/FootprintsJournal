//
//  TestCLVisit.swift
//  FootprintsJournalTests
//
//  Created by Jill Allan on 11/09/2025.
//

import CoreLocation
import Foundation

final class TestCLVisit: CLVisit {
    private let _coordinate: CLLocationCoordinate2D
    private let _horizontalAccuracy: CLLocationAccuracy
    private let _arrivalDate: Date
    private let _departureDate: Date
    
    init(
        coordinate: CLLocationCoordinate2D,
        horizontalAccuracy: CLLocationAccuracy,
        arrivalDate: Date,
        departureDate: Date
    ) {
        self._coordinate = coordinate
        self._horizontalAccuracy = horizontalAccuracy
        self._arrivalDate = arrivalDate
        self._departureDate = departureDate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var coordinate: CLLocationCoordinate2D { _coordinate }
    override var horizontalAccuracy: CLLocationAccuracy { _horizontalAccuracy }
    override var arrivalDate: Date { _arrivalDate }
    override var departureDate: Date { _departureDate }
}
