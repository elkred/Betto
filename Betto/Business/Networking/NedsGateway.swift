//
//  NedsGateway.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Foundation

protocol NedsGatewayProtocol: Sendable {
    func fetchNextRaces(_ count: Int) async throws -> NextRacesResponse
}

struct NedsGateway: NedsGatewayProtocol {

    private let baseURL = "https://api.neds.com.au/rest/v1"

    /// Fetches a number of next races.
    ///
    /// Example endpoint: `https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10`
    /// - Parameter count: The number of races being
    /// - Returns: The network response.
    func fetchNextRaces(_ count: Int) async throws -> NextRacesResponse {
        guard let url = URL(string: "\(baseURL)/racing/?method=nextraces&count=\(count)") else {
            throw URLError(.badURL)
        }

        let request = URLRequest(url: url, timeoutInterval: 30)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(NextRacesResponse.self, from: data)
    }
}
