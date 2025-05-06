//
//  RaceInfoMapperTests.swift
//  BettoTests
//
//  Created by Galen Quinn on 5/5/25.
//

import Testing
@testable import Betto
import Foundation

struct RaceInfoMapperTests {
    
    private let mapper = RaceInfoMapper()
    
    @Test
    func racesNotReturnedIfNextToGoIdsNotValid() async throws {
        let summaries: [String: RaceSummary] = [
            "testId1": .mock(raceId: "testId1"),
            "testId2": .mock(raceId: "testId2"),
            "testId3": .mock(raceId: "testId3")
        ]
        
        let raceIds: [String] = ["testId1", "testId4", "testId3"]
        let races = mapper.mapNextToGo(summaries, to: raceIds, given: [])
        
        #expect(races.count == 2)
        #expect(races.contains(where: { $0.id == "testId1"}) == true)
        #expect(races.contains(where: { $0.id == "testId3"}) == true)
        #expect(races.contains(where: { $0.id == "testId2"}) == false)
    }
    
    @Test
    func racesOnlyReturn5SortedValues() async throws {
        let summaries: [String: RaceSummary] = [
            "testId1": .mock(
                raceId: "testId1",
                advertisedStart: .init(seconds: Int((Date() + 300).timeIntervalSince1970))
            ),
            "testId2": .mock(raceId: "testId2"),
            "testId3": .mock(
                raceId: "testId3",
                advertisedStart: .init(seconds: Int((Date() + 150).timeIntervalSince1970))
            ),
            "testId4": .mock(
                raceId: "testId4",
                advertisedStart: .init(seconds: Int((Date() + 200).timeIntervalSince1970))
            ),
            "testId5": .mock(
                raceId: "testId5",
                advertisedStart: .init(seconds: Int((Date() + 250).timeIntervalSince1970))
            ),
            "testId6": .mock(
                raceId: "testId6",
                advertisedStart: .init(seconds: Int((Date() + 100).timeIntervalSince1970))
            ),
            "testId7": .mock(raceId: "testId7"),
            "testId8": .mock(raceId: "testId8"),
            "testId9": .mock(raceId: "testId9"),
            "testId10": .mock(raceId: "testId10")
        ]
        
        let raceIds: [String] = [
            "testId1", "testId4", "testId3",
            "testId4", "testId5", "testId6",
            "testId7", "testId8", "testId9", "testId10"
        ]
        let races = mapper.mapNextToGo(summaries, to: raceIds, given: [])
        
        let expectedSortedIds = ["testId6", "testId3", "testId4", "testId5", "testId1"]
        #expect(races.count == 5)
        #expect(races.compactMap(\.id) == expectedSortedIds)
        
    }
    
    @Test
    func racesFilteredIfQuickFiltersSet() async throws {
        let summaries: [String: RaceSummary] = [
            "testId1": .mock(raceId: "testId1", categoryId: RaceCategory.greyhound.rawValue),
            "testId2": .mock(raceId: "testId2", categoryId: RaceCategory.horse.rawValue),
            "testId3": .mock(raceId: "testId3", categoryId: RaceCategory.harness.rawValue)
        ]
        
        // 1. One selected
        
        let raceIds: [String] = ["testId1", "testId2", "testId3"]
        let races = mapper.mapNextToGo(summaries, to: raceIds, given: [.greyhound])
        
        #expect(races.count == 1)
        #expect(races.first?.id == "testId1")
        
        // 2. Multiple selected
        
        let races2 = mapper.mapNextToGo(summaries, to: raceIds, given: [.greyhound, .harness])
        
        #expect(races2.count == 2)
        #expect(races2.contains(where: { $0.id == "testId1"}) == true)
        #expect(races2.contains(where: { $0.id == "testId3"}) == true)
        
        // 3. All selected
        
        let races3 = mapper.mapNextToGo(summaries, to: raceIds, given: [.greyhound, .harness, .horse])

        #expect(races3.count == 3)
        #expect(races3.contains(where: { $0.id == "testId1"}) == true)
        #expect(races3.contains(where: { $0.id == "testId2"}) == true)
        #expect(races3.contains(where: { $0.id == "testId3"}) == true)
        
        // 4. None selected
        
        let races4 = mapper.mapNextToGo(summaries, to: raceIds, given: [])

        #expect(races4.count == 3)
        #expect(races4.contains(where: { $0.id == "testId1"}) == true)
        #expect(races4.contains(where: { $0.id == "testId2"}) == true)
        #expect(races4.contains(where: { $0.id == "testId3"}) == true)
    }
    
    @Test
    func mapSubheadline() async throws {
        let subheadline = mapper.mapSubheadline(number: 4, name: "Test Race Name")
        #expect(subheadline == "Race #4 | Test Race Name")
    }

    @Test
    func mapRaceTimeInfoWithVerySoonStartTime() async throws {
        let start = Int((Date() + 120).timeIntervalSince1970)
        let mock = RaceSummary.mock(
            advertisedStart: .init(seconds: start)
        )
        let startTimeInfo = mapper.mapRaceTimeInfo(mock)
        
        #expect(Int(startTimeInfo.startTime.timeIntervalSince1970) == start)
        #expect(startTimeInfo.urgency == .verySoon)
    }
    
    @Test
    func mapRaceTimeInfoWithSoonStartTime() async throws {
        let start = Int((Date() + 600).timeIntervalSince1970)
        let mock = RaceSummary.mock(
            advertisedStart: .init(seconds: start)
        )
        let startTimeInfo = mapper.mapRaceTimeInfo(mock)
        
        #expect(Int(startTimeInfo.startTime.timeIntervalSince1970) == start)
        #expect(startTimeInfo.urgency == .soon)
    }
    
    @Test
    func mapRaceTimeInfoWithRegularStartTime() async throws {
        let start = Int((Date() + 10000).timeIntervalSince1970)
        let mock = RaceSummary.mock(
            advertisedStart: .init(seconds: start)
        )
        let startTimeInfo = mapper.mapRaceTimeInfo(mock)
        
        #expect(Int(startTimeInfo.startTime.timeIntervalSince1970) == start)
        #expect(startTimeInfo.urgency == .regular)
    }

}
