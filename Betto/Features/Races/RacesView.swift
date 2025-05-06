//
//  RacesView.swift
//  Betto
//
//  Created by Galen Quinn on 5/6/25.
//

import SwiftUI

struct RacesView: View {
    
    // MARK: - Init

    @State private var viewModel: RacesViewModel
    
    /// Exposed init for mocking previews.
    init(viewModel: RacesViewModel = RacesViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Environment
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView(message: "Loading races...")
                case .content(let state):
                    List {
                        nextToGo(state)
                        otherSports
                    }
                    .listStyle(.plain)
                case .failure(let error):
                    ErrorView(error: error) {
                        viewModel.load()
                    }
                }
            }
            .navigationTitle("Betto")
            .animation(.default, value: viewModel.state)
        }
        .onAppear { viewModel.load() }
        .onDisappear { viewModel.onDisappear() }
    }
    
    private func nextToGo(_ races: [RaceInfo]) -> some View {
        Section {
            ForEach(races) { info in
                NavigationLink {
                    Text("Detail View")
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(info.meetingName)
                                .font(.headline)
                            
                            Text(info.subheadline)
                                .font(.caption2)

                            if dynamicTypeSize.isAccessibilitySize {
                                raceStartTime(info)
                            }
                        }
                        Spacer()
                        
                        if !dynamicTypeSize.isAccessibilitySize {
                            raceStartTime(info)
                        }
                    }
                }
            }
        } header: {
            VStack(alignment: .leading) {
                Text("Next To Go")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.cyan)
                
                categoryQuickFilters
            }
            .padding(.vertical, 10)
        }
    }

    private var categoryQuickFilters: some View {
        // For larger accessibility sizes a scroll view makes sense.
        ScrollView(.horizontal) {
            HStack {
                categoryQuickFiltersContent
            }
        }
    }
    
    private var categoryQuickFiltersContent: some View {
        ForEach(RaceCategory.allCases) { category in
            Button(category.title, systemImage: category.systemImageName) {
                viewModel.selectedCategoryQuickFilters.formSymmetricDifference([category])
            }
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.background)
            .padding(10)
            .background(
                viewModel.selectedCategoryQuickFilters.contains(category)
                    ? Color.orange : Color.orange.opacity(0.5),
                in: Capsule()
            )
            .accessibilityLabel(Text("\(category.title) category"))
            .accessibilityHint(Text("Select to filter races by \(category.title)"))
        }

    }
    
    private var otherSports: some View {
        Section {
            Text("Lots")
            Text("and")
            Text("lots")
            Text("of")
            Text("filler")
            Text("text")
        } header: {
            Text("Other Sports")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.cyan)
        }
    }
    
    private func raceStartTime(_ info: RaceInfo) -> some View {
        HStack(spacing: 0) {
            if info.raceTimeInfo.startTime <= Date() {
                // This is a bit of a hack...
                // Given the time constraint, using the Text `init(_:style:)` makes the most sense to display
                // relative start time with ease. I would likely do a full formatter implementation if I had more time.
                // Making this start time a component in its self where the id of the view updates based on a timer makes more sense as well.
                // Right now a new response has to come in from the repository for the view to redraw. This causes a bug where for a short instance the
                // time will not update to show a the relative date with the (-) marker.
                Text("-")
            }
            Text(info.raceTimeInfo.startTime, style: .relative)
                .monospacedDigit()
        }
        .font(.caption)
        .foregroundStyle(raceTimeColor(info.raceTimeInfo.urgency))
    }
    
    private func raceTimeColor(_ urgency: RaceInfo.StartTimeInfo.Urgency) -> Color {
        switch urgency {
        case .verySoon: .red
        case .soon: .orange
        case .regular: .primary
        }
    }
}

#Preview {
    RacesView(viewModel: .init(nextToGoResponseMock: .mock()))
}
