//
//  OrganizationRowView.swift
//  ZK Wallet
//
//  Created by Mahith ‎ on 12/6/23.
//

import SwiftUI

struct OrganizationRowView: View {
    let organization: OrganizationModel

    var body: some View {
        HStack {
            Image(systemName: "building.2.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(.trailing, 10)

            Text(organization.name)
        }
    }
}

#Preview {
    OrganizationRowView(organization: OrganizationModel(id: 1, name: "Registry Of Motor Services", code: "RMV", stateId: 1)
    )
}
