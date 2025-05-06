//
//  RacesRepositoryTests.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Testing
@testable import Betto
import Foundation

@Suite(.tags(.networking))
struct RacesRepositoryTests {
    
    private let repository = RacesRepository(gateway: NedsGatewayMock())
    
    @Test
    func fetchNextRacesReturnsMock() async {
        await #expect(throws: Never.self) {
            try await repository.fetchNextRaces(10) == .mock()
        }
    }
    
    @Test
    func nextRacesStreamMock() async {
        var streamIterator = (await repository.nextRacesStream(ttl: 0, count: 0)).makeAsyncIterator()
        
        await #expect(throws: Never.self) {
            try await streamIterator.next() == .mock()
        }
    }
}
    
