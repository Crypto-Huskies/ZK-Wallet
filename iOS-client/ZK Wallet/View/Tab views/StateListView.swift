//
//  AddCardView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct StateListView: View {
    @State var stateModels: [StateModel] = []
    @State var searchTerm = ""

    var filteredStates: [StateModel] {
        guard !searchTerm.isEmpty else {
            return stateModels.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
        return stateModels.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) || $0.code.localizedCaseInsensitiveContains(searchTerm) }
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationStack {
                    List(self.filteredStates) { model in
                        NavigationLink(destination: OrganizationListView(state: model)) {
                            StateRowView(model: model)
                        }
                    }
                    .listStyle(.plain)
                }
                .searchable(text: $searchTerm, prompt: "Search Your State")
                .navigationTitle("Add a Card")
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear(perform: {
                APIManager.shared.getStates { fetchedStates in
                    self.stateModels = fetchedStates
                }
            })
        }
    }
}

#Preview {
    StateListView()
}
