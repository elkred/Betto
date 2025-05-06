//
//  RaceInfoMapper.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Foundation

class RaceInfoMapper {
    func mapNextToGo(
        _ summaries: [String: RaceSummary],
        to nextToGoIds: [String],
        given selectedQuickFilters: Set<RaceCategory>
    ) -> [RaceInfo] {
        let sortedRaces: [RaceInfo] = summaries
            .filter { nextToGoIds.contains($0.key) }
            .compactMap { $0.value }
            .map {
                .init(
                    id: $0.raceId,
                    category: RaceCategory(rawValue: $0.categoryId),
                    meetingName: $0.meetingName,
                    subheadline: mapSubheadline(number: $0.raceNumber, name: $0.raceName),
                    raceTimeInfo: mapRaceTimeInfo($0)
                )
            } // Filter out races where more than 1 min has passed since the start time.
            .filter { $0.raceTimeInfo.startTime >= (Date() - 60) }
            .filter {
                guard !selectedQuickFilters.isEmpty, let category = $0.category
                else { return true }
                
                return selectedQuickFilters.contains(category)
            }
            .sorted { $0.id < $1.id } // Arbitrary sort order so that order is maintained when races have the same start time.
            .sorted { ($0.raceTimeInfo.startTime < $1.raceTimeInfo.startTime) }

        // Only show the first 5 races.
        return Array(sortedRaces.prefix(5))
    }
    
    func mapSubheadline(number: Int, name: String) -> String {
        ["Race #\(number)", name].joined(separator: " | ")
    }
    
    func mapRaceTimeInfo(_ raceSummary: RaceSummary) -> RaceInfo.StartTimeInfo {
        let rawSeconds = raceSummary.advertisedStart.seconds
        let date = Date(timeIntervalSince1970: .init(rawSeconds))
        let minutesUntilRace = Calendar.current.dateComponents(
            [.minute], from: Date(), to: date
        ).minute

        var urgency: RaceInfo.StartTimeInfo.Urgency = .regular
        
        if let minutesUntilRace {
            switch minutesUntilRace {
            case -2...5: urgency = .verySoon
            case 5...15: urgency = .soon
            default: urgency = .regular
            }
        }
        
        return .init(startTime: date, urgency: urgency)
    }
}

struct RaceInfo: Identifiable, Hashable {
    var id: String
    var category: RaceCategory?
    var meetingName: String
    var subheadline: String
    var raceTimeInfo: StartTimeInfo
    
    struct StartTimeInfo: Hashable {
        var startTime: Date
        var urgency: Urgency
        
        enum Urgency: Hashable {
            case verySoon, soon, regular
        }
    }
}
