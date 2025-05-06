//
//  LoadingView.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import SwiftUI

struct LoadingView: View {
    
    var message: String?

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 15) {
                ProgressView()
                    .controlSize(.large)
                if let message {
                    Text(message)
                        .font(.subheadline)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    LoadingView(message: "Loading races...")
}
