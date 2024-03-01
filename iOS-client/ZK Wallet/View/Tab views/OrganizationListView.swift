//
//  OrganizationListView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 11/24/23.
//

import SwiftUI

struct OrganizationListView: View {
    var state: StateModel
    @State private var organizations: [OrganizationModel] = []
    @State private var selectedOrganization: OrganizationModel?

    var body: some View {
        List(organizations) { organization in
            Button(action: {
                self.selectedOrganization = organization
            }) {
                OrganizationRowView(organization: organization)
            }
        }
        .navigationTitle("Orgs. in \(state.name)")
        .onAppear {
            APIManager.shared.getOrganizationsByStateId(stateId: state.id) { fetchedOrganizations in
                self.organizations = fetchedOrganizations
            }
        }
        .sheet(item: $selectedOrganization) { selectedOrg in
            LoginView(organization: selectedOrg)
        }
    }
}

#Preview {
    OrganizationListView(
        state: StateModel(id: 1, name: "California", code: "CA")
    )
}
