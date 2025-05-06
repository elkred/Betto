import Foundation

struct NextRacesResponse: Codable, Hashable {
    let status: Int
    let message: String
    let data: RaceData
}

struct RaceData: Codable, Hashable {
    let nextToGoIds: [String]
    var raceSummaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

struct RaceSummary: Codable, Identifiable, Hashable {
    var id: String { raceId }
    let raceId: String
    let raceName: String
    let raceNumber: Int
    let meetingId: String
    let meetingName: String
    let categoryId: String
    let advertisedStart: AdvertisedStart
    var raceForm: RaceForm?
    let venueId: String
    let venueName: String
    let venueState: String
    let venueCountry: String
    var additionalData: AdditionalData?
    var generated: Int?
    var silkBaseUrl: String?
    var raceComment: String?
    var raceCommentAlternative: String?

    enum CodingKeys: String, CodingKey {
        case raceId = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingId = "meeting_id"
        case meetingName = "meeting_name"
        case categoryId = "category_id"
        case advertisedStart = "advertised_start"
        case raceForm = "race_form"
        case venueId = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
        case additionalData = "additional_data"
        case generated
        case silkBaseUrl = "silk_base_url"
        case raceComment = "race_comment"
        case raceCommentAlternative = "race_comment_alternative"
    }
}

struct AdvertisedStart: Codable, Hashable {
    let seconds: Int
}

struct RaceForm: Codable, Hashable {
    let distance: Int
    let distanceType: DistanceType
    let distanceTypeId: String
    let trackCondition: TrackCondition
    let trackConditionId: String
    var weather: Weather?
    var weatherId: String?
    let raceComment: String?
    let additionalData: String?

    enum CodingKeys: String, CodingKey {
        case distance
        case distanceType = "distance_type"
        case distanceTypeId = "distance_type_id"
        case trackCondition = "track_condition"
        case trackConditionId = "track_condition_id"
        case weather
        case weatherId = "weather_id"
        case raceComment = "race_comment"
        case additionalData = "additional_data"
    }
}

struct DistanceType: Codable, Hashable {
    let id: String
    let name: String
    let shortName: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
    }
}

struct TrackCondition: Codable, Hashable {
    let id: String
    let name: String
    let shortName: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
    }
}

struct Weather: Codable, Hashable {
    let id: String
    let name: String
    let shortName: String
    let iconUri: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortName = "short_name"
        case iconUri = "icon_uri"
    }
}

struct AdditionalData: Codable, Hashable {
    let revealedRaceInfo: RevealedRaceInfo

    enum CodingKeys: String, CodingKey {
        case revealedRaceInfo = "revealed_race_info"
    }
}

struct RevealedRaceInfo: Codable, Hashable {
    let trackName: String
    let state: String
    let country: String
    let number: Int
    let raceName: String
    let time: String
    let `class`: String
    let startType: String
    let prizemonies: Prizemonies
    let localisedPrizemonies: [String: LocalisedPrizemonies]
    let railPosition: String
    let trackDirection: String
    let trackSurface: String
    let group: String
    let gait: String
    let trackHomeStraightMetres: Int
    let trackCircumference: Int

    enum CodingKeys: String, CodingKey {
        case trackName = "track_name"
        case state
        case country
        case number
        case raceName = "race_name"
        case time
        case `class`
        case startType = "start_type"
        case prizemonies
        case localisedPrizemonies = "localised_prizemonies"
        case railPosition = "rail_position"
        case trackDirection = "track_direction"
        case trackSurface = "track_surface"
        case group
        case gait
        case trackHomeStraightMetres = "track_home_straight_metres"
        case trackCircumference = "track_circumference"
    }
}

struct Prizemonies: Codable, Hashable {
    let totalValue: Int?
    let first: Int?
    let second: Int?
    let third: Int?
    let fourth: Int?
    let fifth: Int?
    let sixth: Int?
    let seventh: Int?
    let eighth: Int?
    let ninth: Int?
    let tenth: Int?

    enum CodingKeys: String, CodingKey {
        case totalValue = "total_value"
        case first = "1st"
        case second = "2nd"
        case third = "3rd"
        case fourth = "4th"
        case fifth = "5th"
        case sixth = "6th"
        case seventh = "7th"
        case eighth = "8th"
        case ninth = "9th"
        case tenth = "10th"
    }
}

struct LocalisedPrizemonies: Codable, Hashable {
    let first: Int?
    let second: Int?
    let third: Int?
    let fourth: Int?
    let fifth: Int?
    let sixth: Int?
    let seventh: Int?
    let eighth: Int?
    let ninth: Int?
    let tenth: Int?
    let totalValue: Int?

    enum CodingKeys: String, CodingKey, Hashable {
        case first = "1st"
        case second = "2nd"
        case third = "3rd"
        case fourth = "4th"
        case fifth = "5th"
        case sixth = "6th"
        case seventh = "7th"
        case eighth = "8th"
        case ninth = "9th"
        case tenth = "10th"
        case totalValue = "total_value"
    }
}
