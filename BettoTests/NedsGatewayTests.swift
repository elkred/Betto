//
//  NedsGatewayTests.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import Testing
@testable import Betto
import Foundation

@Suite(.tags(.networking))
struct NedsGatewayTests {
    let gateway = NedsGatewayMock()
    
    @Test
    func gatewayReturnsMock() async throws {
        await #expect(throws: Never.self) {
            try await gateway.fetchNextRaces(10) == .mock()
        }
    }
}
    
