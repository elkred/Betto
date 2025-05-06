//
//  ContentView.swift
//  Betto
//
//  Created by Galen Quinn on 5/5/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Races", systemImage: "figure.equestrian.sports") {
                RacesView()
            }
            
            Tab("Sports", systemImage: "australian.football.fill") {
                Text("Sports")
            }
        }
        .tint(.cyan)
    }
}

#Preview {
    HomeView()
}
