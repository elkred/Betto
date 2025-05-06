//
//  NedsGatewayMock.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

@testable import Betto

struct NedsGatewayMock: NedsGatewayProtocol {
    func fetchNextRaces(_ count: Int) async throws -> NextRacesResponse {
        .mock()
    }
}
