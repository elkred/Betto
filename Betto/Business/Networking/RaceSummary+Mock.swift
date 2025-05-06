//
//  RaceSummary+Mock.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Foundation

extension RaceSummary {
    static func mock(
        raceId: String = "testRaceId",
        categoryId: String = "testCategoryId",
        advertisedStart: AdvertisedStart = .init(seconds: Int(Date.distantFuture.timeIntervalSince1970))
    ) -> RaceSummary {
        .init(
            raceId: raceId,
            raceName: "testRaceName",
            raceNumber: 99,
            meetingId: "testMeetingId",
            meetingName: "testMeetingName",
            categoryId: categoryId,
            advertisedStart: advertisedStart,
            venueId: "testVenueId",
            venueName: "testVenueName",
            venueState: "testVenueState",
            venueCountry: "testVenueCountry"
        )
    }
}
