//
//  NextRacesResponse+Mock.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Foundation

extension NextRacesResponse {
    static func mock() -> NextRacesResponse {
        let verySoonStartTime = (Date() + 100).timeIntervalSince1970
        return .init(
            status: 200,
            message: "",
            data: .init(
                nextToGoIds: ["0", "1", "2"],
                raceSummaries: [
                    "0": .mock(advertisedStart: .init(seconds: Int(verySoonStartTime))),
                    "1": .mock(),
                    "2": .mock()
                ]
            )
        )
    }
}
