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

struct RacesView: View {
    
    
    var body: some View {
        NavigationStack {
            List {
                nextToGo
                
                
            }
            .listStyle(.plain)
            .navigationTitle("Betto")
        }
    }
    
    private var nextToGo: some View {
        Section("Next To Go") {
            
        }
    }
}

@Observable final class RacesViewModel {
    
    
}

struct NedsGateway {
    
    private let baseURL = "https://api.neds.com.au/rest/v1"
    
    "/racing/?method=nextraces&count=10"
    
    func fetchNextRaces() async throws -> [Race] {
        
    }
}




#Preview {
    HomeView()
}
