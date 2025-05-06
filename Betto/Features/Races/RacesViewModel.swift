//
//  RacesViewModel.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Foundation

/// One of the requirements was to `avoid Combine`... Technically, `ObservableObject` is part of the `Combine` framework,
/// so I thought using `@Observable` could be a fun way to stay true to the requirements and use the new `Observeration` framework.
/// Unfortunately, the apps that I work on tend to not have a min version of iOS 17, so this was a nice opportunity to dive a little deeper.
@MainActor @Observable
final class RacesViewModel {
    
    // MARK: - Init
    
    /// Exposed init for mocking previews.
    init(nextToGoResponseMock: NextRacesResponse? = nil) {
        if let nextToGoResponseMock {
            nextToGoRacesResponseState = .content(nextToGoResponseMock)
        }
    }

    // MARK: - State

    /// Exposed state which recalculates when observable properties publish changes.
    var state: LoadingState<[RaceInfo]> {
        // Can be made into a generic `map` extension for `LoadingState` with more time.
        switch nextToGoRacesResponseState {
        case .loading: return .loading
        case .content(let nextRaces):
            return .content(mapper.mapNextToGo(
                nextRaces.data.raceSummaries,
                to: nextRaces.data.nextToGoIds,
                given: selectedCategoryQuickFilters
            ))
        case .failure(let error): return .failure(error)
        }
    }

    var selectedCategoryQuickFilters: Set<RaceCategory> = []
    
    // MARK: - Private State
    
    private var nextToGoRacesResponseState: LoadingState<NextRacesResponse> = .loading
    private var loadAndListenToStreamTask: Task<Void, Never>?
    
    // MARK: - Helpers
    
    @ObservationIgnored
    private let repository = RacesRepository()
    
    @ObservationIgnored
    private let mapper = RaceInfoMapper()
    
    // MARK: - Lifecyle
    
    /// Loads initial data and setups a task to listen for future response changes based on ttl.
    /// - Warning: - This uses an extremely aggressive `TTL` of 5 seconds. I'm not sure what the actual limits/standards are for `Entain`.
    /// With more time, I'd optimize to request a more optimized `TTL` depending on the urgency of a specific race's start time.
    func load() {
        loadAndListenToStreamTask?.cancel()
        loadAndListenToStreamTask = Task {
            do {
                // Fetch initial data.
                nextToGoRacesResponseState = .content(try await repository.fetchNextRaces(10))
                
                // Start up polling stream.
                for try await raceResponse in await repository.nextRacesStream(ttl: 5, count: 10) {
                    nextToGoRacesResponseState = .content(raceResponse)
                }
            } catch {
                nextToGoRacesResponseState = .failure(error)
            }
        }
    }
    
    func onDisappear() {
        loadAndListenToStreamTask?.cancel()
        loadAndListenToStreamTask = nil
    }
}

enum LoadingState<T> {
    case loading
    case content(T)
    case failure(Error)
}

extension LoadingState: Equatable where T: Equatable {
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.content(let lhsValue), .content(let rhsValue)):
            return lhsValue == rhsValue
        case (.failure(let lhsError), .failure(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        default: return false
        }
    }
}

