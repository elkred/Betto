//
//  RacesRepository.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Foundation

/// Repository which manages the fetching and polling of race data.
final actor RacesRepository {

    private let gateway: (any NedsGatewayProtocol)
    
    init(gateway: any NedsGatewayProtocol = NedsGateway()) {
        self.gateway = gateway
    }
    
    func fetchNextRaces(_ count: Int) async throws -> NextRacesResponse {
        try await gateway.fetchNextRaces(count)
    }

    /// Produces a stream of response values which are requested depending on the `ttl` setting.
    ///
    /// - Parameters:
    ///   - ttl: Interval inbetween requests.
    ///   - count: The number of races being requested.
    /// - Returns: A stream of response values from our gateway.
    func nextRacesStream(ttl: Int, count: Int) -> AsyncThrowingStream<NextRacesResponse, Error> {
        AsyncThrowingStream<NextRacesResponse, Error> { [gateway] in
            try? await Task.sleep(for: .seconds(ttl))
            // Delay next request by ttl setting.
            return try await gateway.fetchNextRaces(count)
        }
    }
}
