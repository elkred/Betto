//
//  RaceCategory.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

enum RaceCategory: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    
    var title: String {
        switch self {
        case .horse: "Horse"
        case .harness: "Harness"
        case .greyhound: "Greyhound"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .horse: "figure.equestrian.sports"
        case .harness: "arrow.triangle.2.circlepath.circle"
        case .greyhound: "dog"
        }
    }
}
