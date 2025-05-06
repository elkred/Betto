//
//  ErrorView.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import SwiftUI

struct ErrorView: View {
    
    var error: any Error
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Oops... There was an error.")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.subheadline)
            }
            .padding(5)
                
            Button("Try Again", action: action)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

#Preview {
    ErrorView(error: URLError(.badURL)) {
        // nop
    }
}
